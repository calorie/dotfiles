# shellcheck shell=bash
# Git の状態を 1 回の status 取得で表示する。

# shellcheck source=lib/tmux_adapter.sh
source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"

TMUX_POWERLINE_SEG_VCS_STATUS_MAX_LEN="${TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN:-24}"
TMUX_POWERLINE_SEG_VCS_STATUS_TRUNCATE_SYMBOL="${TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL:-…}"
TMUX_POWERLINE_SEG_VCS_STATUS_BRANCH_SYMBOL="${TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL:-${TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_SYMBOL:-}}"
TMUX_POWERLINE_SEG_VCS_STATUS_BRANCH_SYMBOL_COLOUR="${TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR:-5}"
TMUX_POWERLINE_SEG_VCS_STATUS_AHEAD_SYMBOL="${TMUX_POWERLINE_SEG_VCS_COMPARE_AHEAD_SYMBOL:-↑ }"
TMUX_POWERLINE_SEG_VCS_STATUS_BEHIND_SYMBOL="${TMUX_POWERLINE_SEG_VCS_COMPARE_BEHIND_SYMBOL:-↓ }"
TMUX_POWERLINE_SEG_VCS_STATUS_STAGED_SYMBOL="${TMUX_POWERLINE_SEG_VCS_STAGED_SYMBOL:-⊕ }"
TMUX_POWERLINE_SEG_VCS_STATUS_MODIFIED_SYMBOL="${TMUX_POWERLINE_SEG_VCS_MODIFIED_SYMBOL:-± }"
TMUX_POWERLINE_SEG_VCS_STATUS_UNTRACKED_SYMBOL="${TMUX_POWERLINE_SEG_VCS_OTHERS_SYMBOL:-⋯}"

run_segment() {
	local tmux_path
	local status
	local line
	local oid
	local branch
	local ahead=0
	local behind=0
	local staged=0
	local modified=0
	local untracked=0

	tmux_path=$(tp_get_tmux_cwd) || return 1
	cd "$tmux_path" || return 1

	status=$(GIT_OPTIONAL_LOCKS=0 git status \
		--porcelain=v2 \
		--branch \
		--untracked-files=all \
		2>/dev/null) || return 0

	while IFS= read -r line; do
		case "$line" in
		'# branch.oid '*)
			oid=${line#"# branch.oid "}
			;;
		'# branch.head '*)
			branch=${line#"# branch.head "}
			;;
		'# branch.ab '*)
			local branch_ab
			branch_ab=${line#"# branch.ab "}
			ahead=${branch_ab%% *}
			ahead=${ahead#+}
			behind=${branch_ab##* }
			behind=${behind#-}
			;;
		1\ *|2\ *|u\ *)
			local entry
			local xy
			entry=${line#* }
			xy=${entry%% *}
			if [ "${xy:0:1}" != "." ]; then
				((staged += 1))
			fi
			if [ "${xy:1:1}" != "." ]; then
				((modified += 1))
			fi
			;;
		\?\ *)
			((untracked += 1))
			;;
		esac
	done <<<"$status"

	[ -n "$branch" ] || return 0

	if [ "$branch" = "(detached)" ]; then
		branch=":${oid:0:7}"
	elif [ "${#branch}" -gt "$TMUX_POWERLINE_SEG_VCS_STATUS_MAX_LEN" ]; then
		local branch_length
		branch_length=$((
			TMUX_POWERLINE_SEG_VCS_STATUS_MAX_LEN
			- ${#TMUX_POWERLINE_SEG_VCS_STATUS_TRUNCATE_SYMBOL}
		))
		branch="${branch:0:branch_length}${TMUX_POWERLINE_SEG_VCS_STATUS_TRUNCATE_SYMBOL}"
	fi

	local output
	output="#[fg=colour${TMUX_POWERLINE_SEG_VCS_STATUS_BRANCH_SYMBOL_COLOUR}]"
	output+="${TMUX_POWERLINE_SEG_VCS_STATUS_BRANCH_SYMBOL} "
	output+="#[fg=${TMUX_POWERLINE_CUR_SEGMENT_FG}]${branch}"

	if ((behind > 0)); then
		output+=" ${TMUX_POWERLINE_SEG_VCS_STATUS_BEHIND_SYMBOL}${behind}"
	fi
	if ((ahead > 0)); then
		output+=" ${TMUX_POWERLINE_SEG_VCS_STATUS_AHEAD_SYMBOL}${ahead}"
	fi
	if ((staged > 0)); then
		output+=" ${TMUX_POWERLINE_SEG_VCS_STATUS_STAGED_SYMBOL}${staged}"
	fi
	if ((modified > 0)); then
		output+=" ${TMUX_POWERLINE_SEG_VCS_STATUS_MODIFIED_SYMBOL}${modified}"
	fi
	if ((untracked > 0)); then
		output+=" ${TMUX_POWERLINE_SEG_VCS_STATUS_UNTRACKED_SYMBOL} ${untracked}"
	fi

	printf '%s\n' "$output"
}
