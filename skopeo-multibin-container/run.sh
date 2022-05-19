#!/usr/bin/env bash

# The version of skopeo to use.
version="${INPUT_VERSION}"
# The source image transport to use.
src_transport="${INPUT_SRCTRANSPORT}"
# The destination image transport to use.
dst_transport="${INPUT_DSTTRANSPORT}"
# The source image.
src_img="${INPUT_SRCIMG}"
# The destination image.
dst_img="${INPUT_DSTIMG}"
# Skopeo flags. No validation is performed on these, but they
# should not include --username or --password. No guarantee
# that these will work if they require additional data (e.g.
# certs path).
flags="${INPUT_SKOPEOCOPYFLAGS}"

# username for authentication.
username="${INPUT_USERNAME}"
# password for authentication.
password="${INPUT_PASSWORD}"
# registry to authenticate against. We shouldn't technically
# need this because the user provided source and destination
# images, but until that's coded up, we'll do this.
registry="${INPUT_REGISTRY}"

# For convenience, set the path of the bin to check.
skopeo_bin="skopeo-bin/skopeo-${version}"

# Workaround for Github Actions. This image uses local filesystem
# locations for certain things, and the GitHub Actions environment
# recommends against using WORKDIR in your image in favor of its use of GITHUB_WORKSPACE.
# For this reason we will CD into the WORKDIR in this script.
echo "Changing directory into /opt/" && cd /opt/

# Ensure we support the version requested by the user.
stat "${skopeo_bin}" &>/dev/null || { echo "The version of skopeo you requested (\"${version}\") is not supported" ; exit 1 ;}
stat "transports/${src_transport}" &>/dev/null || { echo "The transport you requested (\"${src_transport}\") is not supported" ; exit 1 ;}
stat "transports/${dst_transport}" &>/dev/null || { echo "The transport you requested (\"${dst_transport}\") is not supported" ; exit 1 ;}

# These files contain the transport string itself. Read this from the filesystem.
# This is just a lazy mapping in case the user-provided parameter does not directly
# match the transport string. 
src_transport_str=$(cat "transports/${src_transport}")
dst_transport_str=$(cat "transports/${dst_transport}")

echo "Logging in!"
./${skopeo_bin} login -u "${username}" -p "${password}" "${registry}" || exit 2

# debug!
echo "Running: ./${skopeo_bin} copy "${flags}" ${src_transport_str}${src_img} ${dst_transport_str}${dst_img}"
./${skopeo_bin} copy ${flags} ${src_transport_str}${src_img} ${dst_transport_str}${dst_img}

echo "Logging out!"
./${skopeo_bin} logout --all