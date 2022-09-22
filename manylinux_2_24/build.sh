#!/usr/bin/env bash

function build() {
    PLATFORM=${1}
    DOCKERFILE=${2}
    TAG=${3}
    docker buildx build \
        --platform "$PLATFORM" \
        --build-arg="http_proxy=$http_proxy" \
        --build-arg="https_proxy=$https_proxy" \
        --build-arg="PLATFORM=$PLATFORM" \
        -f ${DOCKERFILE} \
        --push \
        -t "quara/manylinux_2_24:${TAG}" \
        .
}


function main() {

    PLATFORM=${1:-"linux/amd64"}

    case "$PLATFORM" in

        linux/amd64)
            echo "Building for platform: linux/amd64"
            build $PLATFORM Dockerfile.amd64 amd64
            ;;

        linux/arm64)
            echo "Building for platform: linux/arm64"
            build $PLATFORM Dockerfile.arm64 arm64
            ;;

        linux/arm/v7)
            echo "Building for platform: linux/arm/v7"
            build $PLATFORM Dockerfile.armv7 armv7
            ;;

        manifest)
            echo -e "Building manifest for multi-arch image"
            # Create manifest
            docker manifest create quara/manylinux:2_24 \
                quara/manylinux_2_24:amd64 \
                quara/manylinux_2_24:arm64 \
                quara/manylinux_2_24:armv7
            # Push manifest
            docker manifest push quara/manylinux:2_24
            ;;

        --help)
            echo -e "Build docker images which can be use to create manylinux_2_24 wheels\n"
            echo -e "Example usages:"
            echo -e "  ./build.sh linux/amd64"
            echo -e "  ./build.sh linux/arm64"
            echo -e "  ./build.sh linux/arm/v7"
            echo -e "\nThis command can also be used to build a manifest:\n"
            echo -e "  ./build.sh manifest"
            ;;

        *)
            echo -n "Unsupported platform: {$PLATFORM}"
            ;;
    esac
}


main $@
