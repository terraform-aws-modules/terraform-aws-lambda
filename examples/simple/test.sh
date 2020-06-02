#!/usr/bin/env bash
# vim:ts=4:sw=4:noet

#set -eo pipefail

trap ctrl_c INT

ctrl_c() {
	echo "** Trapped CTRL-C"
	exit 1
}

failed=0

:echo() {
	local color=${2:-"33;1"}
	echo -e "\e[${color}m$1\e[0m"
}

:note() {
	:echo "$1" "35;1"
}

:case() {
	if [ $? -ne 0 ]
	then failed=1
	fi

	if [ "$failed" -eq 1 ]
	then :echo "SKIPPED: $1"; return 1
	else echo; :echo "CASE: $1"
	fi
}

terraform=$(which terraform)
terraform() {
	$terraform "$@" < <(yes yes)
}

:note "Preparing ..."
:echo "Destroy / Remove ZIP files"
terraform destroy
rm builds/*.zip 2>/dev/null || true

:echo
:note "Running test cases"

:case "Double apply" && {
	terraform apply && \
	terraform apply
}

:case "Remove ZIP files / Double apply" && {
	rm builds/*.zip
	terraform apply && \
	terraform apply
}

:case "Destroy / Double apply" && {
	terraform destroy
	terraform apply && \
	terraform apply
}

#:case "Destroy / Remove ZIP files" && {
#	terraform plan -destroy
#	terraform destroy -auto-approve
#	rm builds/*.zip
#}
