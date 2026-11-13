#!/usr/bin/env bash
# Packages the JetBrains theme plugin into dist/carbon-jetbrains-<version>.jar.
# A theme-only plugin needs no compilation: the jar holds plugin.xml and the theme files.
set -euo pipefail
cd "$(dirname "$0")"
version=$(sed -n 's/.*<version>\(.*\)<\/version>.*/\1/p' resources/META-INF/plugin.xml | head -1)
dist="../dist"; out="$dist/carbon-jetbrains-$version.jar"
mkdir -p "$dist"; rm -f "$out"
xmllint --noout resources/META-INF/plugin.xml resources/themes/Carbon.xml
for f in resources/*.theme.json; do python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f"; done
(cd resources && zip -q -r "../$out" META-INF ./*.theme.json themes)
echo "built $out"
echo "install: Settings > Plugins > gear icon > Install Plugin from Disk"
