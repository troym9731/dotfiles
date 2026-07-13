use std::path::Path;
use std::time::Duration;

use crate::proc;

const GREY: &str = "\x1b[38;2;108;108;108m"; // #6c6c6c
const PURPLE: &str = "\x1b[35m";
const GREEN: &str = "\x1b[32m";
const CYAN: &str = "\x1b[36m";
const RESET: &str = "\x1b[0m";

#[derive(Default)]
struct Status {
    branch: Option<String>,
    oid: Option<String>,
    ahead: u32,
    behind: u32,
    conflicted: bool,
    deleted: bool,
    renamed: bool,
    modified: bool,
    staged: bool,
    untracked: bool,
    stashed: u32,
}

/// Branch, ahead/behind and per-file flags all come from ONE subprocess:
/// `git status --porcelain=2 --branch`. Stash count is a plain reflog file read
/// (no subprocess). Reproduces Starship's `git_branch` + `git_status` output.
pub fn render(root: &Path) -> Option<String> {
    let out = proc::capture(
        "git",
        &["status", "--porcelain=2", "--branch"],
        Duration::from_millis(400),
    )?;
    let mut st = parse(&out);
    st.stashed = stash_count(root);
    Some(paint(&st))
}

fn parse(out: &str) -> Status {
    let mut st = Status::default();
    for line in out.lines() {
        if let Some(rest) = line.strip_prefix("# branch.head ") {
            if rest != "(detached)" {
                st.branch = Some(rest.to_string());
            }
        } else if let Some(rest) = line.strip_prefix("# branch.oid ") {
            st.oid = Some(rest.chars().take(7).collect());
        } else if let Some(rest) = line.strip_prefix("# branch.ab ") {
            for tok in rest.split_whitespace() {
                if let Some(n) = tok.strip_prefix('+') {
                    st.ahead = n.parse().unwrap_or(0);
                } else if let Some(n) = tok.strip_prefix('-') {
                    st.behind = n.parse().unwrap_or(0);
                }
            }
        } else if line.starts_with("1 ") || line.starts_with("2 ") {
            // Field 1 is the two-char XY status: X = index (staged), Y = worktree.
            if let Some(xy) = line.split_whitespace().nth(1) {
                let mut ch = xy.chars();
                let x = ch.next().unwrap_or('.');
                let y = ch.next().unwrap_or('.');
                if line.starts_with("2 ") || x == 'R' || y == 'R' {
                    st.renamed = true;
                }
                if x == 'D' || y == 'D' {
                    st.deleted = true;
                }
                if y == 'M' || y == 'T' {
                    st.modified = true;
                }
                if x != '.' {
                    st.staged = true;
                }
            }
        } else if line.starts_with("u ") {
            st.conflicted = true;
        } else if line.starts_with("? ") {
            st.untracked = true;
        }
    }
    st
}

fn paint(st: &Status) -> String {
    let mut s = String::new();

    // Branch name in grey; short commit id when detached.
    let name = st.branch.as_deref().or(st.oid.as_deref()).unwrap_or_default();
    s.push_str(GREY);
    s.push_str(name);
    s.push_str(RESET);

    // Starship's `$all_status` order: conflicted, stashed, deleted, renamed,
    // modified, staged, untracked.
    if st.conflicted {
        tok(&mut s, PURPLE, "=");
    }
    if st.stashed > 0 {
        tok(&mut s, PURPLE, "$");
    }
    if st.deleted {
        tok(&mut s, PURPLE, "✗");
    }
    if st.renamed {
        tok(&mut s, PURPLE, "»");
    }
    if st.modified {
        tok(&mut s, PURPLE, "*");
    }
    if st.staged {
        tok(&mut s, GREEN, "✓");
    }
    if st.untracked {
        tok(&mut s, PURPLE, "?");
    }

    // ahead / behind / diverged
    match (st.ahead > 0, st.behind > 0) {
        (true, true) => tok(&mut s, CYAN, "⇕"),
        (true, false) => tok(&mut s, CYAN, "⇡"),
        (false, true) => tok(&mut s, CYAN, "⇣"),
        (false, false) => {}
    }

    s
}

fn tok(s: &mut String, color: &str, sym: &str) {
    s.push_str(color);
    s.push_str(sym);
    s.push_str(RESET);
}

/// Stash count = entries in the stash reflog. Reads the reflog file directly so
/// there's no extra subprocess. Handles the standard `.git` directory and the
/// worktree/submodule `.git`-file (`gitdir: <path>`) case; linked-worktree
/// commondirs and the reftables backend are TODO (fall back to `git stash list`).
fn stash_count(root: &Path) -> u32 {
    let dot_git = root.join(".git");
    let git_dir = if dot_git.is_dir() {
        dot_git
    } else if dot_git.is_file() {
        let gitdir = std::fs::read_to_string(&dot_git).ok().and_then(|c| {
            c.lines()
                .find_map(|l| l.strip_prefix("gitdir: ").map(|p| p.trim().to_string()))
        });
        match gitdir {
            Some(p) if Path::new(&p).is_absolute() => Path::new(&p).to_path_buf(),
            Some(p) => root.join(p),
            None => return 0,
        }
    } else {
        return 0;
    };

    match std::fs::read_to_string(git_dir.join("logs/refs/stash")) {
        Ok(c) => c.lines().filter(|l| !l.trim().is_empty()).count() as u32,
        Err(_) => 0,
    }
}
