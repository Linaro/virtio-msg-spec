#!/bin/bash

PREFIX="PATCH RFC v1"
SUBJECT="virtio-msg transport layer"
ME="$(git config --get user.name) <$(git config --get user.email)>"
ME2="Mr Fake <wm.a.mills+mrfake@gmail.com>"
REAL=virtio-comment@lists.linux.dev
US=virtio-msg@lists.linaro.org
CC="Bertrand Marquis <bertrand.marquis@arm.com>,
Edgar E. Iglesias <edgar.iglesias@amd.com>,
Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
Viresh Kumar <viresh.kumar@linaro.org>,
Alex Bennee <alex.bennee@linaro.org>"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
SINCE=${BRANCH}-patch-base
IGNORE_TOP=0

MY_DIR=$(dirname $0)
BASE_DIR=$(cd $MY_DIR/../..; pwd)

case $1 in
--for-real)
    TO="$REAL"
    ;;
--just-us)
    TO="$US"
    ;;
--just-me)
    TO="$ME"
    CC="$ME2"
    EXTRA_SEND_OPTS="--no-signed-off-by-cc"
    ;;
--dry-run)
    TO="$ME"
    EXTRA_SEND_OPTS="--dry-run"
    ;;
*)
    echo "Need --for-real, --just-us, or --just-me"; exit 2
    ;;
esac

rm -rf "$BASE_DIR"/.prjinfo/sendmail/patches

git format-patch -o "$BASE_DIR"/.prjinfo/sendmail/patches --cover-letter \
    --subject-prefix="$PREFIX" ${SINCE}..HEAD~${IGNORE_TOP}

# fixup the cover letter
(
    cd "$BASE_DIR"/.prjinfo/sendmail/patches;
    sed -i -e "s/\*\*\* SUBJECT HERE \*\*\*/${SUBJECT}/"  0000-cover-letter.patch
    sed -i -e "/\*\*\* BLURB HERE \*\*\*/ r ../cover.txt" 0000-cover-letter.patch
    sed -i -e "/\*\*\* BLURB HERE \*\*\*/ d" 0000-cover-letter.patch
)

git send-email --to="$TO" --cc="$CC" $EXTRA_SEND_OPTS \
    "$BASE_DIR"/.prjinfo/sendmail/patches
