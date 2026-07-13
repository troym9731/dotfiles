use std::path::PathBuf;

/// A repository root plus which VCS markers it carries. Colocated jj repos hold
/// both `.jj` and `.git`.
pub struct Repo {
    pub root: PathBuf,
    pub git: bool,
    pub jj: bool,
}

/// Walk up from the working directory to the first ancestor holding a `.git`
/// and/or `.jj` marker. Pure filesystem stat — no subprocess.
pub fn find_repo() -> Option<Repo> {
    let mut dir: PathBuf = std::env::current_dir().ok()?;
    loop {
        let git = dir.join(".git").exists();
        let jj = dir.join(".jj").exists();
        if git || jj {
            return Some(Repo { root: dir, git, jj });
        }
        if !dir.pop() {
            return None;
        }
    }
}
