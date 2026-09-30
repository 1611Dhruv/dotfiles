# tmux-powerline configuration.
#
# Tracked in dotfiles; symlinked to ~/.config/tmux-powerline/config.sh.
# Only overrides live here — every setting not listed falls back to the
# plugin's config/defaults.sh and themes/. See README.md.
#
# Modeline {
#	 vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=4 filetype=sh
# }

# General {
	# Print the failing segment and its exit code into the status bar.
	export TMUX_POWERLINE_DEBUG_MODE_ENABLED="false"
	# kitty.conf uses Hack Nerd Font. Set "false" on a terminal without a
	# patched font, or the separators and glyphs render as tofu.
	export TMUX_POWERLINE_PATCHED_FONT_IN_USE="true"

	export TMUX_POWERLINE_THEME="night"
	# Overlay dirs for local themes/segments; the plugin's own are the fallback.
	export TMUX_POWERLINE_DIR_USER_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"
	export TMUX_POWERLINE_DIR_USER_SEGMENTS="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/segments"

	export TMUX_POWERLINE_STATUS_VISIBILITY="on"
	# 5s rather than the upstream 1s: every segment re-runs on each tick, and
	# a 1s cadence on a laptop buys a redraw nobody reads.
	export TMUX_POWERLINE_STATUS_INTERVAL="5"
	# absolute-centre needs tmux >= 3.2; it centres the window list against the
	# whole bar instead of the gap left over by the side segments.
	export TMUX_POWERLINE_STATUS_JUSTIFICATION="absolute-centre"
	export TMUX_POWERLINE_STATUS_LEFT_LENGTH="60"
	export TMUX_POWERLINE_STATUS_RIGHT_LENGTH="60"
	export TMUX_POWERLINE_WINDOW_STATUS_SEPARATOR=""

	# Hide one side of the bar: <prefix> C-[ (left), <prefix> C-] (right).
	#export TMUX_POWERLINE_MUTE_LEFT_KEYBINDING="C-["
	#export TMUX_POWERLINE_MUTE_RIGHT_KEYBINDING="C-]"
# }

# Segments {
	# Plain arrays, deliberately not `export` — bash cannot export arrays, and
	# the theme fills these in only when unset, so assigning here overrides
	# night.sh without touching the TPM-managed plugin tree.
	#
	# Format: segment bg fg [separator] [sep_bg] [sep_fg] [spacing] [sep_toggle]
	# Colours: name, #rrggbb, 0-255, or default/terminal. Run the plugin's
	# color_palette.sh to see the 256-colour palette.
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info #0B335F #ffffff"
		"mode_indicator 165 0"
		"vcs_branch 29 88"
	)

	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"vcs_compare 60 255"
		"pwd #2B3045 #FFFFFF"
		"battery #002147 #EEF4ED"
		"time #22D4FF #08273A"
	)
# }

# battery.sh {
	# {percentage, cute, hearts}
	export TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
# }

# mode_indicator.sh {
	# Mouse mode is on unconditionally in .tmux.conf, so displaying it carries
	# no information. prefix (C-Space is easy to fat-finger) and copy do.
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_MOUSE_MODE_ENABLED="false"
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_NORMAL_AND_PREFIX_MODE_ENABLED="true"
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_NORMAL_MODE_TEXT="normal"
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_PREFIX_MODE_TEXT="prefix"
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_COPY_MODE_TEXT="copy"
	export TMUX_POWERLINE_SEG_MODE_INDICATOR_SEPARATOR_TEXT=" • "
# }

# pwd.sh {
	export TMUX_POWERLINE_SEG_PWD_MAX_LEN="40"
# }

# time.sh {
	# One segment instead of date_day + date + time.
	export TMUX_POWERLINE_SEG_TIME_FORMAT="%a %d %b %H:%M"
	# TZ identifier, e.g. "America/Chicago", to override the system zone.
	#export TMUX_POWERLINE_SEG_TIME_TZ=""
# }

# tmux_session_info.sh {
	export TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I.#P"
# }

# vcs_branch.sh {
	export TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN="24"
	export TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL="…"
	export TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_SYMBOL=""
	export TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR="5"
# }

# Optional segments — add the name to an array above to enable {
	# weather: yr.no wants a *signed* longitude. Madison, WI is
	# 43.0722 / -89.4008; the unsigned 89.4008 lands in western China.
	#export TMUX_POWERLINE_SEG_WEATHER_DATA_PROVIDER="yrno"
	#export TMUX_POWERLINE_SEG_WEATHER_UNIT="c"
	#export TMUX_POWERLINE_SEG_WEATHER_UPDATE_PERIOD="600"
	#export TMUX_POWERLINE_SEG_WEATHER_JSON="jq"
	#TMUX_POWERLINE_SEG_WEATHER_LAT="43.0722"
	#TMUX_POWERLINE_SEG_WEATHER_LON="-89.4008"

	# now_playing: the player is OS-specific. shell_is_osx is already defined
	# by the time this file is sourced (config/shell.sh loads first).
	#if shell_is_osx; then
	#	export TMUX_POWERLINE_SEG_NOW_PLAYING_MUSIC_PLAYER="spotify"
	#else
	#	export TMUX_POWERLINE_SEG_NOW_PLAYING_MUSIC_PLAYER="playerctl"
	#	export TMUX_POWERLINE_SEG_NOW_PLAYING_PLAYERCTL_FORMAT="{{ artist }} - {{ title }}"
	#fi
	#export TMUX_POWERLINE_SEG_NOW_PLAYING_MAX_LEN="25"
	# "roll" animates the title, but only looks right at STATUS_INTERVAL=1.
	#export TMUX_POWERLINE_SEG_NOW_PLAYING_TRIM_METHOD="trim"

	#export TMUX_POWERLINE_SEG_DISK_USAGE_FILESYSTEM="/"
	#export TMUX_POWERLINE_SEG_HOSTNAME_FORMAT="short"
# }

# Local overrides {
	# Machine-specific values and anything secret (API tokens, passwords).
	# Untracked — see README.md.
	_tmux_powerline_local="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/local.sh"
	# shellcheck disable=SC1090
	[ -f "$_tmux_powerline_local" ] && source "$_tmux_powerline_local"
	unset _tmux_powerline_local
# }
