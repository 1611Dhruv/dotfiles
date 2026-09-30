# tmux-powerline

Status bar config for [erikw/tmux-powerline](https://github.com/erikw/tmux-powerline).

Only `config.sh` is tracked here. The plugin itself is installed and updated by
TPM at `~/.tmux/plugins/tmux-powerline` (see the `@plugin` line in `.tmux.conf`)
and must never be committed into this repo — `.gitignore` enforces that.

## Install

```bash
mkdir -p ~/.config/tmux-powerline
ln -sf ~/dotfiles/tmux-powerline/config.sh ~/.config/tmux-powerline/config.sh
tmux source-file ~/.tmux.conf
```

The plugin reads exactly one path, `$XDG_CONFIG_HOME/tmux-powerline/config.sh`
(falling back to `~/.config`), so the symlink is the whole installation.

Requirements: bash, a Nerd Font in the terminal (kitty is set to Hack Nerd Font),
and tmux >= 3.2 for `absolute-centre`. `jq` is only needed for the optional
weather segment.

## What the bar shows

| Side  | Segments |
| ----- | -------- |
| left  | `tmux_session_info` · `mode_indicator` · `vcs_branch` |
| right | `vcs_compare` · `pwd` · `battery` · `time` |

Window list is centred between them. Every one of these segments works on both
macOS and Linux, so the same file is correct on the Hyprland box.

## Changing segments

Edit the two arrays in the `# Segments {` fold:

```bash
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
	"segment_name background foreground [separator] [sep_bg] [sep_fg] [spacing] [sep_toggle]"
)
```

Two things that are easy to get wrong:

- These are **plain array assignments, not `export`** — bash cannot export an
  array. The theme (`themes/night.sh`) only populates them when they are unset,
  which is why assigning them here overrides the theme without editing the
  plugin tree that TPM overwrites on update.
- Colours are names, `#rrggbb`, `0`-`255`, or `default`/`terminal`. Run
  `~/.tmux/plugins/tmux-powerline/color_palette.sh` to see the 256-colour set.

Apply with `tmux source-file ~/.tmux.conf`. Segment list changes sometimes need
a `tmux kill-server` to take effect.

Available segment names are the filenames in
`~/.tmux/plugins/tmux-powerline/segments/`. A few are pre-configured but
disabled in the `# Optional segments` fold — uncomment the settings and add the
name to an array. To preview one side without restarting tmux:

```bash
~/.tmux/plugins/tmux-powerline/powerline.sh right
```

## Secrets and per-machine values

`config.sh` ends by sourcing `~/.config/tmux-powerline/local.sh` if it exists.
That file is **not** tracked. Anything private or host-specific goes there —
the upstream default config has slots for a GitHub notifications token, Gmail
password, and OpenWeather/Last.fm/Tautulli API keys, none of which belong in a
git repo:

```bash
# ~/.config/tmux-powerline/local.sh
export TMUX_POWERLINE_SEG_GITHUB_NOTIFICATIONS_TOKEN="ghp_..."
```

## Notes on the defaults chosen here

- `STATUS_INTERVAL=5` instead of upstream's `1`. Every segment re-runs on each
  tick; at 1s a shell-out-per-second segment (`now_playing` on macOS drives
  AppleScript) costs real CPU on battery for a redraw nobody reads.
- `mode_indicator` has mouse mode disabled — `.tmux.conf` sets `mouse on`
  globally, so the indicator would always read the same thing.
- One `time` segment with format `%a %d %b %H:%M` replaces the theme's three
  `date_day` + `date` + `time` segments.
- Dropped from the generated default (all were unused, or misconfigured):
  `air`, `earthquake`, `gcalcli`, `github_notifications`, `ifstat`,
  `kubernetes_context`, `lan_ip`/`wan_ip`, `mailcount` (pointed at a
  non-existent `~/.mail` and `~/.mailcheckrc`), `now_playing` (set to
  `apple_music`), `vpn`, `weather` (longitude was missing its minus sign, so it
  reported the weather in Xinjiang), `xkb_layout`.

The full commented default — every variable the plugin supports — can be
regenerated any time without clobbering this file:

```bash
~/.tmux/plugins/tmux-powerline/generate_config.sh
# writes ~/.config/tmux-powerline/config.sh.default
```
