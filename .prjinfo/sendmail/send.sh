#!/bin/bash

SUBJECT="virtio-msg transport layer"
ME="$(git config --get user.name) <$(git config --get user.email)>"
ME2="Mr Fake <wm.a.mills+mrfake@gmail.com>"
REAL=virtio-comment@lists.linux.dev
US=virtio-msg@lists.linaro.org
CC="Bertrand Marquis <bertrand.marquis@arm.com>,
Edgar E. Iglesias <edgar.iglesias@amd.com>,
Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
Viresh Kumar <viresh.kumar@linaro.org>,
Alex Bennee <alex.bennee@linaro.org>,
Armelle Laine <armellel@google.com>"

UPSTREAM_BRANCH_DEFAULT=master
UPSTREAM_BRANCH=$UPSTREAM_BRANCH_DEFAULT
UPSTREAM_BRANCH_SET=0
REROLL_COUNT_DEFAULT=2
REROLL_COUNT=$REROLL_COUNT_DEFAULT
REROLL_COUNT_SET=0
RFC_OPT=
IGNORE_TOP_DEFAULT=2
IGNORE_TOP=$IGNORE_TOP_DEFAULT
IGNORE_TOP_SET=0
IGNORE_BOTTOM_DEFAULT=5
IGNORE_BOTTOM=$IGNORE_BOTTOM_DEFAULT
IGNORE_BOTTOM_SET=0
PATCH_COUNT=

MY_DIR=$(dirname $0)
BASE_DIR=$(cd $MY_DIR/../..; pwd)

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] MODE

Prepare the virtio-msg patch series and submit it with git send-email.

Modes:
  --for-real   Send to $REAL and CC the reviewer list.
  --just-us    Send to $US and CC the reviewer list.
  --just-me    Send to the configured git user and CC the fake test address.
  --dry-run    Run git send-email --dry-run to the configured git user.

Options:
  -v N, --reroll-count N
               Mark the series as the Nth reroll. Default: $REROLL_COUNT_DEFAULT.
  --rfc        Mark the series as RFC.
  --upstream REF
               Use REF as the upstream branch for merge-base. Default:
               $UPSTREAM_BRANCH_DEFAULT.
  --skip-top N, --ignore-top N
               Skip the last N commits before HEAD. Default: $IGNORE_TOP_DEFAULT.
  --patch-count N, --include-count N
               Include exactly N patches after the skipped top commits. When
               set, the script does not use upstream refs, range tags, or
               --skip-bottom.
  --skip-bottom N, --ignore-bottom N
               Skip the first N commits after the base if <branch>-patch-base
               is not present. Default: $IGNORE_BOTTOM_DEFAULT.
  -h, -?, --help
               Show this help text.

Patch range:
  With --patch-count N, the included range is:

    HEAD~(skip-top + patch-count)..HEAD~skip-top

  Without --patch-count, the base commit is tag <branch>-merge-base, if
  present, otherwise the merge base of $UPSTREAM_BRANCH_DEFAULT and HEAD by
  default.

  The bottom range boundary is selected from tag <branch>-patch-base, if
  present.  Otherwise, the script skips the first $IGNORE_BOTTOM_DEFAULT
  commits after the base by default.

  The script also skips the last $IGNORE_TOP_DEFAULT commits before HEAD by
  default.

Generated files:
  $BASE_DIR/.prjinfo/sendmail/patches
EOF
}

set_mode() {
    if [ -n "$MODE" ]; then
        echo "Only one mode can be specified" >&2
        usage >&2
        exit 2
    fi

    MODE=$1
    case $MODE in
    --for-real)
        TO="$REAL"
        ;;
    --just-us)
        TO="$US"
        EXTRA_SEND_OPTS="--no-signed-off-by-cc --suppress-cc=author"
        ;;
    --just-me)
        TO="$ME"
        CC="$ME2"
        EXTRA_SEND_OPTS="--no-signed-off-by-cc --suppress-cc=author"
        ;;
    --dry-run)
        TO="$ME"
        EXTRA_SEND_OPTS="--dry-run"
        ;;
    esac
}

while [ $# -gt 0 ]; do
    case $1 in
    --for-real|--just-us|--just-me|--dry-run)
        set_mode "$1"
        shift
        ;;
    -v|--reroll-count)
        if [ $# -lt 2 ] || [ "${2#-}" != "$2" ]; then
            echo "$1 requires an argument" >&2
            usage >&2
            exit 2
        fi
        REROLL_COUNT=$2
        REROLL_COUNT_SET=1
        shift 2
        ;;
    -v[0-9]*)
        REROLL_COUNT=${1#-v}
        REROLL_COUNT_SET=1
        shift
        ;;
    --reroll-count=*)
        REROLL_COUNT=${1#--reroll-count=}
        REROLL_COUNT_SET=1
        shift
        ;;
    --rfc)
        RFC_OPT=--rfc
        shift
        ;;
    --upstream)
        if [ $# -lt 2 ] || [ "${2#-}" != "$2" ]; then
            echo "$1 requires an argument" >&2
            usage >&2
            exit 2
        fi
        UPSTREAM_BRANCH=$2
        UPSTREAM_BRANCH_SET=1
        shift 2
        ;;
    --upstream=*)
        UPSTREAM_BRANCH=${1#--upstream=}
        UPSTREAM_BRANCH_SET=1
        shift
        ;;
    --skip-top|--ignore-top)
        if [ $# -lt 2 ] || [ "${2#-}" != "$2" ]; then
            echo "$1 requires an argument" >&2
            usage >&2
            exit 2
        fi
        IGNORE_TOP=$2
        IGNORE_TOP_SET=1
        shift 2
        ;;
    --skip-top=*|--ignore-top=*)
        IGNORE_TOP=${1#*=}
        IGNORE_TOP_SET=1
        shift
        ;;
    --patch-count|--include-count)
        if [ $# -lt 2 ] || [ "${2#-}" != "$2" ]; then
            echo "$1 requires an argument" >&2
            usage >&2
            exit 2
        fi
        PATCH_COUNT=$2
        shift 2
        ;;
    --patch-count=*|--include-count=*)
        PATCH_COUNT=${1#*=}
        shift
        ;;
    --skip-bottom|--ignore-bottom)
        if [ $# -lt 2 ] || [ "${2#-}" != "$2" ]; then
            echo "$1 requires an argument" >&2
            usage >&2
            exit 2
        fi
        IGNORE_BOTTOM=$2
        IGNORE_BOTTOM_SET=1
        shift 2
        ;;
    --skip-bottom=*|--ignore-bottom=*)
        IGNORE_BOTTOM=${1#*=}
        IGNORE_BOTTOM_SET=1
        shift
        ;;
    -h|-\?|--help)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 2
        ;;
    esac
done

case $REROLL_COUNT in
''|*[!0-9]*|0)
    echo "Reroll count must be a positive integer" >&2
    usage >&2
    exit 2
    ;;
esac

case $IGNORE_TOP in
''|*[!0-9]*)
    echo "Skip-top count must be a non-negative integer" >&2
    usage >&2
    exit 2
    ;;
esac

case $IGNORE_BOTTOM in
''|*[!0-9]*)
    echo "Skip-bottom count must be a non-negative integer" >&2
    usage >&2
    exit 2
    ;;
esac

case $PATCH_COUNT in
''|*[!0-9]*|0)
    if [ -n "$PATCH_COUNT" ]; then
        echo "Patch count must be a positive integer" >&2
        usage >&2
        exit 2
    fi
    ;;
esac

if [ -z "$UPSTREAM_BRANCH" ]; then
    echo "Upstream ref must not be empty" >&2
    usage >&2
    exit 2
fi

if [ -z "$MODE" ]; then
    echo "A mode must be specified" >&2
    usage >&2
    exit 2
fi

get_tag() {
    git show-ref --tag --hash $1 2>/dev/null
}

BRANCH=$(git rev-parse --abbrev-ref HEAD)

TOP=$(git log -n 1 --format=%H HEAD~${IGNORE_TOP})
if [ -z "${TOP}" ]; then
    echo "Can't top commit (last included commit)" >&2
    exit 3
fi

if [ -n "$PATCH_COUNT" ]; then
    BOTTOM_SKIP=$(( IGNORE_TOP + PATCH_COUNT ))
    SINCE=$(git log -n 1 --format=%H HEAD~${BOTTOM_SKIP})
    if [ -z "${SINCE}" ]; then
        echo "Can't find bottom commit (first excluded commit)" >&2
        exit 3
    fi
    BASE=
else
    BASE=$(get_tag ${BRANCH}-merge-base)
    if [ -z "${BASE}" ]; then
        BASE=$(git merge-base ${UPSTREAM_BRANCH} HEAD)
    fi
    if [ -z "${BASE}" ]; then
        echo "Can't find base commit (common ancestor)" >&2
        exit 3
    fi

    SINCE=$(get_tag ${BRANCH}-patch-base)
    if [ -z "${SINCE}" ]; then
        SINCE=$(git log --reverse --format=%H ${BASE}..HEAD | head -n $(( $IGNORE_BOTTOM + 0 )) | tail -n 1 )
    fi
    if [ -z "${SINCE}" ]; then
        echo "Can't find patch base commit (first included commit)" >&2
        exit 3
    fi
fi

if false; then
    echo "BASE:  $(git log -n 1 --oneline $BASE)"
    echo "SINCE: $(git log -n 1 --oneline $SINCE)"
    echo "TOP:   $(git log -n 1 --oneline $TOP)"
    echo "HEAD:  $(git log -n 1 --oneline HEAD)"
fi

echo "Patch options:"
if [ -n "$PATCH_COUNT" ]; then
    echo "Selection mode: patch count"
else
    echo "Selection mode: upstream range"
    if [ "$UPSTREAM_BRANCH_SET" -eq 0 ]; then
        echo "Upstream ref: $UPSTREAM_BRANCH (default)"
    else
        echo "Upstream ref: $UPSTREAM_BRANCH"
    fi
fi
if [ "$REROLL_COUNT_SET" -eq 0 ]; then
    echo "Reroll count: $REROLL_COUNT (default)"
else
    echo "Reroll count: $REROLL_COUNT"
fi
if [ -n "$RFC_OPT" ]; then
    echo "RFC: yes"
else
    echo "RFC: no"
fi
if [ "$IGNORE_TOP_SET" -eq 0 ]; then
    echo "Skip top commits: $IGNORE_TOP (default)"
else
    echo "Skip top commits: $IGNORE_TOP"
fi
if [ -n "$PATCH_COUNT" ]; then
    echo "Patch count: $PATCH_COUNT"
else
    if [ "$IGNORE_BOTTOM_SET" -eq 0 ]; then
        echo "Skip bottom commits: $IGNORE_BOTTOM (default)"
    else
        echo "Skip bottom commits: $IGNORE_BOTTOM"
    fi
fi
echo

echo "Ignore top commits:"
git -P log --oneline ${TOP}..HEAD
echo
echo "Include commits:"
git -P log --oneline ${SINCE}..${TOP}
echo
if [ -n "$PATCH_COUNT" ]; then
    echo "Ignore bottom commits:"
    git -P log --oneline -n 10 ${SINCE}
    echo
else
    echo "Ignore bottom commits:"
    git -P log --oneline ${BASE}..${SINCE}
    echo
fi

echo "^c to cancel, enter to proceed"
read

# example commands
# git log -n 1 --oneline --no-abbrev-commit virtio-msg-patch2-patch-basey
# git log --reverse --oneline --no-abbrev-commit a1883517ee44cc03d1b621a331d24a6f5cc08a92..HEAD | head -n $(( 5 + 1 )) | tail -n 1

patch_dir="$BASE_DIR"/.prjinfo/sendmail/patches

rm -rf "$patch_dir"

if ! git format-patch -o "$patch_dir" --cover-letter \
    --reroll-count="$REROLL_COUNT" $RFC_OPT ${SINCE}..HEAD~${IGNORE_TOP}; then
    exit 1
fi

# fixup the cover letter
set -- "$patch_dir"/*0000-cover-letter.patch
if [ $# -ne 1 ] || [ ! -f "$1" ]; then
    echo "Can't find generated cover letter" >&2
    exit 1
fi
cover_patch=$1
cover_tmp=$(mktemp "${cover_patch}.XXXXXX") || exit 1

awk -v subject="$SUBJECT" -v blurb="$BASE_DIR"/.prjinfo/sendmail/cover.txt '
{
    gsub(/\*\*\* SUBJECT HERE \*\*\*/, subject)
    if ($0 ~ /\*\*\* BLURB HERE \*\*\*/) {
        while ((getline line < blurb) > 0)
            print line
        close(blurb)
        next
    }
    print
}
' "$cover_patch" > "$cover_tmp"
if [ $? -ne 0 ]; then
    rm -f "$cover_tmp"
    exit 1
fi
if ! mv "$cover_tmp" "$cover_patch"; then
    rm -f "$cover_tmp"
    exit 1
fi

git send-email --to="$TO" --cc="$CC" $EXTRA_SEND_OPTS \
    "$patch_dir"
