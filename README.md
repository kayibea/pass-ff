# pass-ff

Minimal `fzf`-based fuzzy finder extension for **GNU Pass**.

Select a password entry interactively and forward it to any `pass` subcommand.

---

## Requirements

- `pass`
- `fzf`

---

## Installation

```bash
mkdir -p ~/.password-store/.extensions
cp ff.bash ~/.password-store/.extensions/ff.bash
chmod +x ~/.password-store/.extensions/ff.bash
```

---

## Usage

```
pass ff [pass-args] -- [initial-query]
```

### Examples

```bash
pass ff show
pass ff show -- github
pass ff -c
pass ff edit
```

- Arguments before `--` are passed to `pass`
- Arguments after `--` are used as the initial `fzf` query


## Integration with other extensions

`pass-ff` does not care what it forwards the selected entry to.

Any existing or third-party `pass` extension works automatically, as long as it follows the normal `pass <subcommand> <entry>` pattern.

Example using the [age](https://github.com/kayibea/pass-age.git) extension:

```bash
pass ff age
1762069510      9 weeks ago     wifi-passwd.txt
```
