#!/usr/bin/env bash
# Validates the Zed theme against the Zed theme schema and packages the
# extension into dist/carbon-zed-<version>.zip.
set -euo pipefail
cd "$(dirname "$0")"
version=$(sed -n 's/^version = "\(.*\)"/\1/p' extension.toml)
dist="../dist"; out="$dist/carbon-zed-$version.zip"
schema_url=$(python3 -c 'import json;print(json.load(open("themes/carbon.json"))["$schema"])')
mkdir -p "$dist"; rm -f "$out"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
curl -sSfL "$schema_url" -o "$tmp/schema.json"
python3 - "$tmp/schema.json" <<'PY'
import json, sys
try:
    import jsonschema
except ImportError:
    sys.exit("jsonschema missing: pip install jsonschema")
schema = json.load(open(sys.argv[1]))
theme = json.load(open("themes/carbon.json"))
jsonschema.validate(theme, schema)
print("themes/carbon.json: schema OK")
PY
zip -q -r "$out" extension.toml themes
echo "built $out"
echo "install: 'zed: install dev extension' and pick this directory, or copy themes/carbon.json to ~/.config/zed/themes/"
