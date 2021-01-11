#!/bin/sh
set -eu

# Trigger build eldesh/coq on dockerhub.
#
# e.g.
# $ ./build.sh < supported_builds


CONTENT_TYPE_JSON='Content-Type: application/json'

# Set build triggering url.
# This url would be acquired from dockerhub:
#   Repositories > eldesh/coq > Builds > Configure Automated Builds
#
# e.g.
#   https://hub.docker.com/api/build/v1/source/xxxxxxxx/trigger/xxxxxxxx/call/
BUILD_TRIGGER_URL=${BUILD_TRIGGER_URL}

# Create an json object specifies the type of the build.
#
# # Details
# build_type DockerTag tag  source
# build_type Branch    source
# build_type Tag       source
#
# # Examples
# build_type DockerTag latest master
# build_type Branch    v8.3
build_type () {
	variant=$1
	case $variant in
	DockerTag)
		docker_tag=$2
		source_name=$3
		data="{\"docker_tag\": \"${docker_tag}\", \"source_name\":\"${source_name}\"}"
		;;
	Branch | Tag)
		source_type=$variant
		source_name=$2
		data="{\"source_type\": \"${source_type}\", \"source_name\":\"${source_name}\"}"
		;;
	*)
		echo "Unknown variant type: $variant" >&2
		echo "variant should be one of DockerTag, Branch or Tag" >&2
		exit 1
		;;
	esac

	# data ::=
	#     { "docker_tag": string, "source_name": "master" }
	#   | { "source_type": source_type, "source_name": string }
	# source_type ::= Branch | Tag
	echo $data
}

trigger_build () {
	version=$1

	if [ $version = "latest" ]; then
		data=$(build_type DockerTag $version master)
	else
		data=$(build_type Branch $version)
	fi
	#debug
	#echo "data: $data"

	curl \
		-X POST \
		-H "$CONTENT_TYPE_JSON" \
		--data "$data" \
		$BUILD_TRIGGER_URL
	echo ""
	# {"error": string} or
	# {"autotests": "OFF", "build_in_farm": true, "build_settings": ["/api/build/v1/setting/xxxxxx/", "/api/build/v1/setting/xxxxxx/", "/api/build/v1/setting/xxxxxx/", "/api/build/v1/setting/xxxxxx/"], "channel": "Stable", "deploykey": "", "envvars": [], "image": "eldesh/coq", "owner": "eldesh", "provider": "Github", "repo_links": true, "repository": "docker-coq", "resource_uri": "/api/build/v1/source/xxxxxx/", "state": "Failed", "uuid": "xxxxxx"}
}

build_all () {
	while read ver
	do
		echo "trigger: $ver"
		trigger_build $ver
	done
}

main () {
	vers=`mktemp`
	trap "rm $vers" EXIT
	sed -n -e '/^[^#]/p' > $vers
	build_all < $vers
}

main "$@"

