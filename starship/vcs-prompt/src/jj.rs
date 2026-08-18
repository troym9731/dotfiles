use std::collections::{HashMap, HashSet, VecDeque};
use std::path::Path;
use std::sync::Arc;

use jj_lib::backend::CommitId;
use jj_lib::config::{ConfigLayer, ConfigSource, StackedConfig};
use jj_lib::hex_util::encode_reverse_hex;
use jj_lib::object_id::ObjectId;
use jj_lib::ref_name::RefName;
use jj_lib::repo::{ReadonlyRepo, Repo, StoreFactories};
use jj_lib::settings::UserSettings;
use jj_lib::view::View;
use jj_lib::workspace::{default_working_copy_factories, Workspace};
use pollster::FutureExt;

const BRIGHT_MAGENTA: &str = "\x1b[95m"; // change-id unique prefix
const BRIGHT_BLACK: &str = "\x1b[90m"; // change-id remainder
const GREEN: &str = "\x1b[32m"; // bookmarks
const RED: &str = "\x1b[31m"; // conflict / divergent
const PURPLE: &str = "\x1b[35m"; // changes without description (matches git modified)
const CYAN: &str = "\x1b[36m"; // unsynced with remote (matches git ahead)
const RESET: &str = "\x1b[0m";

const ID_LENGTH: usize = 8;
const ANCESTOR_DEPTH: usize = 10;
const BOOKMARKS_LIMIT: usize = 3;

struct JjInfo {
    change_id: String,
    change_id_prefix_len: usize,
    /// (name, distance): distance 0 = directly on `@`, 1+ = ancestor depth.
    bookmarks: Vec<(String, usize)>,
    empty_commit: bool,
    empty_desc: bool,
    conflict: bool,
    divergent: bool,
    unsynced: bool,
}

/// Minimal read-only settings. jj requires user.name/email even to load; the
/// values are irrelevant since we never write.
fn user_settings() -> Option<UserSettings> {
    let mut config = StackedConfig::with_defaults();
    let mut layer = ConfigLayer::empty(ConfigSource::User);
    layer.set_value("user.name", "vcs-prompt").ok()?;
    layer.set_value("user.email", "vcs-prompt@localhost").ok()?;
    config.add_layer(layer);
    UserSettings::from_config(config).ok()
}

/// BFS up the ancestor graph collecting the nearest local bookmark at each
/// commit, recording the shortest distance per bookmark. Depth-capped.
fn find_ancestor_bookmarks(
    repo: &Arc<ReadonlyRepo>,
    view: &View,
    wc_id: &CommitId,
    max_depth: usize,
) -> Vec<(String, usize)> {
    let mut queue: VecDeque<(CommitId, usize)> = VecDeque::new();
    let mut visited: HashSet<CommitId> = HashSet::new();
    let mut found: HashMap<String, usize> = HashMap::new();

    let Ok(wc) = repo.store().get_commit(wc_id) else {
        return Vec::new();
    };
    for parent in wc.parent_ids() {
        queue.push_back((parent.clone(), 1));
    }

    while let Some((id, depth)) = queue.pop_front() {
        if depth > max_depth || !visited.insert(id.clone()) {
            continue;
        }
        for (name, _) in view.local_bookmarks_for_commit(&id) {
            found.entry(name.as_str().to_string()).or_insert(depth);
        }
        if depth < max_depth {
            if let Ok(commit) = repo.store().get_commit(&id) {
                for parent in commit.parent_ids() {
                    queue.push_back((parent.clone(), depth + 1));
                }
            }
        }
    }

    let mut result: Vec<(String, usize)> = found.into_iter().collect();
    result.sort_by_key(|(_, distance)| *distance);
    result
}

fn collect(root: &Path) -> Option<JjInfo> {
    let settings = user_settings()?;
    let workspace = Workspace::load(
        &settings,
        root,
        &StoreFactories::default(),
        &default_working_copy_factories(),
    )
    .ok()?;

    let repo = workspace.repo_loader().load_at_head().block_on().ok()?;
    let view = repo.view();
    let wc_id = view.wc_commit_ids().get(workspace.workspace_name())?.clone();
    let commit = repo.store().get_commit(&wc_id).ok()?;

    let full = encode_reverse_hex(commit.change_id().as_bytes());
    let change_id = full[..ID_LENGTH.min(full.len())].to_string();
    let change_id_prefix_len = repo
        .shortest_unique_change_id_prefix_len(commit.change_id())
        .unwrap_or(ID_LENGTH)
        .min(change_id.len());

    let empty_desc = commit.description().trim().is_empty();
    let empty_commit = commit.is_empty(repo.as_ref()).block_on().ok()?;
    let conflict = commit.has_conflict();

    let mut bookmarks: Vec<(String, usize)> = view
        .local_bookmarks_for_commit(&wc_id)
        .map(|(name, _)| (name.as_str().to_string(), 0))
        .collect();
    if ANCESTOR_DEPTH > 0 {
        bookmarks.extend(find_ancestor_bookmarks(&repo, view, &wc_id, ANCESTOR_DEPTH));
    }

    let divergent = repo
        .resolve_change_id(commit.change_id())
        .ok()
        .flatten()
        .is_some_and(|targets| targets.is_divergent());

    // Is the closest bookmark out of sync with its remote? Skip the colocated
    // `git` pseudo-remote; a bookmark with no real remote counts as synced.
    let unsynced = bookmarks.first().is_some_and(|(name, _)| {
        let local = view.get_local_bookmark(RefName::new(name));
        let mut has_remote = false;
        let mut synced = false;
        for (symbol, remote_ref) in view.all_remote_bookmarks() {
            if symbol.remote.as_str() == "git" || symbol.name.as_str() != name.as_str() {
                continue;
            }
            has_remote = true;
            if remote_ref.target == *local {
                synced = true;
                break;
            }
        }
        has_remote && !synced
    });

    Some(JjInfo {
        change_id,
        change_id_prefix_len,
        bookmarks,
        empty_commit,
        empty_desc,
        conflict,
        divergent,
        unsynced,
    })
}

fn paint(info: &JjInfo) -> String {
    let mut out = String::new();

    // change-id: unique prefix bright, remainder gray (jj log style)
    let plen = info.change_id_prefix_len.min(info.change_id.len());
    out.push_str(BRIGHT_MAGENTA);
    out.push_str(&info.change_id[..plen]);
    out.push_str(RESET);
    let rest = &info.change_id[plen..];
    if !rest.is_empty() {
        out.push_str(BRIGHT_BLACK);
        out.push_str(rest);
        out.push_str(RESET);
    }

    // bookmarks: `name` or `name~distance`, capped with `…+N` overflow
    if !info.bookmarks.is_empty() {
        let total = info.bookmarks.len();
        let show = if BOOKMARKS_LIMIT == 0 {
            total
        } else {
            BOOKMARKS_LIMIT.min(total)
        };
        let mut parts: Vec<String> = info
            .bookmarks
            .iter()
            .take(show)
            .map(|(name, dist)| {
                if *dist > 0 {
                    format!("{name}~{dist}")
                } else {
                    name.clone()
                }
            })
            .collect();
        let hidden = total - show;
        if hidden > 0 {
            parts.push(format!("…+{hidden}"));
        }
        out.push(' ');
        out.push_str(GREEN);
        out.push_str(&parts.join(", "));
        out.push_str(RESET);
    }

    // status flags, colored to match their git analog where one exists:
    // `!` conflict, `⇔` divergent, `*` changes-without-description, `⇡` unsynced
    let changes = info.empty_desc && !info.empty_commit;
    if info.conflict || info.divergent || changes || info.unsynced {
        out.push(' ');
        if info.conflict {
            tok(&mut out, RED, "!");
        }
        if info.divergent {
            tok(&mut out, RED, "⇔");
        }
        if changes {
            tok(&mut out, PURPLE, "*");
        }
        if info.unsynced {
            tok(&mut out, CYAN, "⇡");
        }
    }

    out
}

fn tok(out: &mut String, color: &str, sym: &str) {
    out.push_str(color);
    out.push_str(sym);
    out.push_str(RESET);
}

/// Render the jj segment for the repo at `root`, or `None` on any failure so
/// the prompt degrades to empty rather than blocking.
pub fn render(root: &Path) -> Option<String> {
    let info = collect(root)?;
    Some(paint(&info))
}
