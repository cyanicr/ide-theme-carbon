# Carbon Theme

A minimalist dark theme using comfortable UI colors, maintained for multiple
editors.

This repository is a fork of the [Carbon theme for JetBrains IDEs](https://github.com/luisfer0793/theme-carbon)
by Luis Fernando Jiménez. The fork keeps the original JetBrains theme and adds
ports of the same palette to other editors: Zed and OpenIDEA.

## Editors

| Editor | Directory | Notes |
| --- | --- | --- |
| JetBrains IDEs | `jetbrains/` | Original dark theme, forked |
| Zed | `zed/` | Port of the JetBrains theme |
| OpenIDEA | `openidea/` | Port of the JetBrains theme |

## Building

`./build.sh` builds every editor package into `dist/`. Each editor directory
also has its own `build.sh`.

### JetBrains IDEs

```sh
./jetbrains/build.sh
```

Produces `dist/carbon-jetbrains-<version>.jar`. Install it from
**Settings > Plugins > gear icon > Install Plugin from Disk**, then choose
**Carbon** under
**Settings > Appearance & Behavior > Appearance > Theme**.

The theme also supports the Islands UI (IntelliJ platform 2026.1 and newer),
where the editor and tool windows float as rounded islands on a lighter frame.
Turn on **Settings > Advanced Settings > Enable Islands UI for custom themes**
and restart the IDE.

The theme is defined by
`jetbrains/resources/matte_carbon_basics.theme.json` (UI colors) and
`jetbrains/resources/themes/Carbon.xml` (editor color scheme).
Requires `xmllint`, `python3` and `zip`.

### Zed

```sh
./zed/build.sh
```

Validates `zed/themes/carbon.json` against the Zed theme schema and produces
`dist/carbon-zed-<version>.zip`. Requires `python3` with the `jsonschema`
package, `curl` and `zip`.

To use the theme, either copy it into your user themes:

```sh
cp zed/themes/carbon.json ~/.config/zed/themes/
```

or install the `zed/` directory as a dev extension with
`zed: install dev extension` from the command palette. Then pick **Carbon** from `theme selector: toggle`.

### OpenIDEA

```sh
./openidea/build.sh
```

Checks the theme files against the rules OpenIDEA's plugin host applies and
produces `dist/carbon-openidea-<version>.zip`. Requires `python3` and `zip`.

The plugin is data only, so the `openidea/` directory is the package. In
**Settings > Plugins > gear icon**, choose **Install Plugin from Disk** and pick
the `openidea/` directory, or **Install Plugin from Package File** and pick the
zip. Then choose **Carbon** under
**Settings > Appearance & Behavior > Appearance > Theme**.

The theme is a pair of files in `openidea/themes/`: `carbon.theme.json` holds the UI
colors and `carbon.scheme.json` the editor colors (syntax, editor, terminal palette).
The keys are OpenIDEA's CSS variable tokens, listed in its
[theme guide](https://github.com/l0ng-ai/openidea/blob/main/docs/en/plugins/guides/themes.mdx).
A token the theme leaves out keeps the value of the built-in Islands theme.

## Credits

- Original Carbon theme: [Luis Fernando Jiménez](https://github.com/luisfer0793) ([luisfer0793/theme-carbon](https://github.com/luisfer0793/theme-carbon))
- Fork, Zed port and OpenIDEA port: Richard Baltariu

## License

Contributions in this repository are licensed under the [MIT License](LICENSE).

The theme is derived from the original Carbon theme by Luis Fernando Jiménez,
which is distributed under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). The
original files have been modified in this fork. See [NOTICE](NOTICE) for
details.
