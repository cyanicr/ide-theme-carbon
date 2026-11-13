#!/usr/bin/env bash
# Checks the OpenIDEA theme files against the rules the IDE's plugin host applies
# and packages the plugin into dist/carbon-openidea-<version>.zip.
set -euo pipefail
cd "$(dirname "$0")"
version=$(sed -n 's/^version = "\(.*\)"/\1/p' plugin.toml)
mkdir -p ../dist
out="$(cd ../dist && pwd)/carbon-openidea-$version.zip"
rm -f "$out"
python3 - <<'PY'
import json, re, sys

# Same limits as OpenIDEA's crates/ide-host/src/plugins/theme.rs.
NAME = re.compile(r"--[a-z0-9-]{1,62}")
BAD = (";", "{", "}", "<", ">", "\\", "\n", "\r", "url(", "image(", "@import", "expression(")

def tokens(path):
    doc = json.load(open(path))
    for name, value in doc["tokens"].items():
        ok = isinstance(value, str) and value.strip() and len(value) <= 256 and not any(b in value.lower() for b in BAD)
        if not NAME.fullmatch(name) or not ok:
            sys.exit(f"{path}: invalid token {name!r}: {value!r}")
    return doc

manifest = open("plugin.toml").read()
themes = re.findall(r'^path = "(.*)"\neditor-scheme = "(.*)"$', manifest, re.M)
if not themes:
    sys.exit("plugin.toml: no [[contributes.themes]] entries found")
ids = set()
for theme_path, scheme_path in themes:
    theme, scheme = tokens(theme_path), tokens(scheme_path)
    if not re.fullmatch(r"[a-z0-9][a-z0-9_-]*", theme.get("id", "")) or theme["id"] in ids:
        sys.exit(f"{theme_path}: missing, invalid or duplicate id")
    ids.add(theme["id"])
    if not theme.get("name", "").strip() or theme.get("kind") not in ("dark", "light"):
        sys.exit(f"{theme_path}: needs a name and a kind of dark or light")
    if len({**theme["tokens"], **scheme["tokens"]}) > 512:
        sys.exit(f"{theme_path}: more than 512 tokens")
    print(f"{theme_path} + {scheme_path}: OK")
PY
zip -q -r "$out" plugin.toml themes
(cd .. && zip -q "$out" LICENSE NOTICE)
echo "built $out"
echo "install: Settings > Plugins > gear icon > Install Plugin from Disk (this directory) or Install Plugin from Package File (the zip)"
