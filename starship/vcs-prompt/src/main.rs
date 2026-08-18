mod detect;
mod git;
mod jj;
mod proc;

use std::env;
use std::process::ExitCode;

use detect::Repo;

fn main() -> ExitCode {
    let cmd = env::args().nth(1).unwrap_or_default();
    match cmd.as_str() {
        // Cheap gate for Starship's `when = "vcs-prompt detect"`.
        "detect" => match detect::find_repo() {
            Some(_) => ExitCode::SUCCESS,
            None => ExitCode::FAILURE,
        },
        // Anything else (incl. "render") draws the segment.
        _ => {
            if let Some(repo) = detect::find_repo() {
                if let Some(out) = render(&repo) {
                    print!("{out}");
                }
            }
            ExitCode::SUCCESS
        }
    }
}

/// jj takes precedence in colocated repos; otherwise fall back to git.
fn render(repo: &Repo) -> Option<String> {
    if repo.jj {
        if let Some(seg) = jj::render(&repo.root) {
            return Some(seg);
        }
    }
    if repo.git {
        return git::render(&repo.root);
    }
    None
}
