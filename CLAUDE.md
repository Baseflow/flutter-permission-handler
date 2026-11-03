@AGENTS.md

## Claude Code

Everything tool-neutral lives in `AGENTS.md` (imported above). Keep it that way: only add
things here that are specific to Claude Code, and put any new project rule in `AGENTS.md`
so other agents and human contributors pick it up too.

### Tooling in this checkout

- Use the plain `flutter` / `dart` commands in `AGENTS.md`. They are what CI runs and
  what a contributor will have. If this checkout happens to carry a local fvm pin
  (`.fvmrc` is gitignored, so it may or may not) prefix with `fvm`. Do not add one,
  and do not tell anyone they need fvm to work on this repo.
- `flutter run` in any `<package>/example/` is long-running. Ask before starting it
  and don't leave it running in the background. The same goes for the iOS and
  Windows example builds, which take minutes.
- `dart run permission_handler_apple:select` writes into the example's `ios/Flutter/`
  and clears Swift Package Manager caches. Its outputs are gitignored in the example;
  in any other app, check `git status` after running it and do not commit them.
- `cd` into the right package before format, analyze and test. `flutter pub get`
  resolves the whole workspace from anywhere, but the other commands act on the
  current directory.

### Working style

- Prefer the file tools (Read / Edit / Grep / Glob) over `cat`/`sed`/`grep` in Bash for
  reading and editing repo files.
- Use the `Explore` subagent for questions that span the Dart, Java, Objective-C and
  C++ sides at once, which adding a permission always does. For anything inside one
  package, a targeted `Grep` is faster.
- After changing `permission_handler_platform_interface/lib/`, grep the three native
  plugins and `permission_handler_html/lib/` before calling it done. The interface
  analyzes clean on its own while a native side no longer matches it.
- Run `/code-review` on the diff before handing work over, and `/security-review` when
  a change touches how permissions are requested or reported:
  `PermissionManager.java` in `permission_handler_android`, the `strategies/` in
  `permission_handler_apple`, `permission_handler_html/lib/web_delegate.dart`, or the
  `Info.plist` reading in `Package.swift` and `bin/select.dart`.

### Commits and PRs

- Follow the PR workflow in `AGENTS.md`, and check the user's access before the
  first push (`gh api repos/Baseflow/flutter-permission-handler --jq
  .permissions.admin`). For a repository admin, push branches straight to
  `Baseflow/flutter-permission-handler` and open the PR from there. Do not use or
  create a fork. For anyone else, push to their fork and never to a `Baseflow`
  branch. Never push to `main`. Target `main`.
- Never run `dart pub publish`, dry run or otherwise, and never push a release tag,
  unless the user asked for that release in this session.
- End commit messages with:

  ```
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

- End PR descriptions with:

  ```
  🤖 Generated with [Claude Code](https://claude.com/claude-code)
  ```
