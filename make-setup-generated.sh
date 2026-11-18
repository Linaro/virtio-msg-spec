#! /bin/sh
#
# Generate version and metadata preamble for the document
#

DATESTR=${DATESTR:-`cat REVISION-DATE 2>/dev/null`}

# If a second argument is passed we extract what we can from git
# metadata (closest lightweight tag) and local tree status. This
# allows locally generated copies to be tagged appropriately.
#
# The formal build process skips this.
if ! test -z "$2"; then
    TAG=$(git describe --dirty --tags)
    # base date on now
    DATESTR=$(date +'%d %B %Y')
    COMMIT=$(git rev-parse --short HEAD)

    # Finally check if we have un-committed changes in the tree
    if ! git diff-index --quiet HEAD -- ; then
        COMMIT="$COMMIT with local changes"
    fi
fi

case "$1" in
    *-wd*)
	STAGE=wd
	STAGENAME="Working Draft"
	;;
    *-os*)
	STAGE=os
	STAGENAME="OASIS Standard"
	WORKINGDRAFT=""
	;;
    *-csd*)
	STAGE=csd
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	;;
    *-csprd*)
	STAGE=csprd
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csprd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	STAGEEXTRATITLE=" / \newline Public Review Draft $WORKINGDRAFT"
	STAGEEXTRA=" / Public Review Draft $WORKINGDRAFT"
	;;
    *-cs*)
	STAGE=cs
	WORKINGDRAFT=`basename "$1" | sed 's/.*-cs//'`
	STAGENAME="Committee Specification $WORKINGDRAFT"
	;;
    *)
	echo Unknown doc type >&2
	exit 1
esac

VERSION=`echo "$1"| sed -e 's/virtio-v//' -e 's/-.*//'`

#
# Finally if we are building a local draft copy append the commit
# details to the end of the working draft
#
if ! test -z "$COMMIT" ; then
    STAGEEXTRATITLE="$STAGEEXTRATITLE (@ git $COMMIT)"
fi

#Prepend OASIS unless already there
case "$STAGENAME" in
	OASIS*)
		OASISSTAGENAME="$STAGENAME"
		;;
	*)
		OASISSTAGENAME="OASIS $STAGENAME"
		;;
esac

cat > setup-generated.tex <<EOF
% define VIRTIO Working Draft number and date
\newcommand{\virtiorev}{$VERSION}
\newcommand{\virtioworkingdraftdate}{$DATESTR}
\newcommand{\virtioworkingdraft}{$WORKINGDRAFT}
\newcommand{\virtiodraftstage}{$STAGE}
\newcommand{\virtiodraftstageextra}{$STAGEEXTRA}
\newcommand{\virtiodraftstageextratitle}{$STAGEEXTRATITLE}
\newcommand{\virtiodraftstagename}{$STAGENAME}
\newcommand{\virtiodraftoasisstagename}{$OASISSTAGENAME}
EOF
