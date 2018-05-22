#!/bin/bash
#
# by Mary Liu 5/22/2018
#
# this shell script accepts a single directory argument.
# it then changes the names of each item in that directory to 
# remove the following characters: space, square brackets, question mark,
# asterisk, and semi-colon. If changing the name would result in 
# a name collision, the item is skipped.
#
# when normalize is finished, it outputs the number of names changed
#
error() {
    echo "$(basename "$0"): ERROR - $*" >&2
	errors=true
}
fatal() {
	error "$*"
    echo "syntax: $(basename "$0") directory" >&2
	exit 1
}

[ $# -ne 1 ] && fatal "single argument required" 


[ ! -d "$1" -o ! -w "$1" ] && \
	fatal "argument must be a writable directory" 

nchanged=0

for item in "$1"/*; do
	orig=$(basename "$item")
	changed=$(echo "$orig" | tr -d ' ;*?][' )
	[ "$orig" = "$changed" ] && continue
	[ -e "$1/$changed" ] && \
		error "cannot change '$orig', '$changed' exists" && continue
	if mv "$item" "$1/$changed" 2>/dev/null; then
		((nchanged=nchanged+1))
	else
		error "cannot change name of '$orig' to '$changed'"
		continue
	fi
done
echo "$nchanged items changed"
[ "$errors" = true ] && exit 1 
exit 0


