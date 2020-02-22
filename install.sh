#!/usr/bin/env bash
set -euo pipefail

# Who cares about the pick and shovel man
# Who cares if others use him as a tool
# It's part of the aristocratic plan
# To keep the poor man working like a mule.

# These are hard coded behavior directives.
ONYMA=shuhvl
OUR_DIR="~/.${ONYMA}"
OUR_BINS="${OUR_DIR}/bin"

COMPANION_CONTAINER=samrees/shuhvl:latest
ACQUIRE_DEPS_FUNC=_http_dep_fetcher

# utility function, sees if element is in an array
contains() {
  a="${3}[@]"
  [[ "empty" == "${!a:-empty}" ]] && return 1
  for e in "${!a}"; do [[ "${e}" == "${1}" ]] && return 0; done
  return 1
}

dockerized_curl() {
  local url fingerprint download_dir local_filename local_target
  url="${1}"           # ex: https://someserver.tld/somepath
  download_dir="${2}"  # ex: ~/somepath (note lack of trailing slash)
  fingerprint="${3:-}" # ex: 8c5a80011215fdc9d0280eea4b7242c4 (128bit blake2b) or empty

  local_filename="${url##*/}"
  local_target="${download_dir}/${local_filename}"

  # return early if we have the right file
  if [[ -f "${local_target}" && -n "${fingerprint}" ]]; then
    [[ "$(docker run -i -v ${local_target}:/lt ${COMPANION_CONTAINER} bash -c "b2sum -l 128 /lt | cut -d'' -f1)" == "${fingerprint}" ]] && return 0
  fi

  curl --fail --silent "${url}" > "${local_target}"

  if [[ "${fingerprint}" != "false" ]]; then
    if [[ "$(shasum "${local_target}" | cut -d " " -f1)" == "${fingerprint}" ]]; then
      update_after_hooks "${local_filename}"
      return 0
    else
      echo "Error: SHA sum mismatch for "${url}", does not match "${fingerprint}", exiting immediately."
      return 1
    fi
  fi
}

# implements the ACQUIRE_DEPS interface
_http_dep_fetcher() {
  https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep-11.0.2-x86_64-apple-darwin.tar.gz
  https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
  https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64-apple-darwin.tar.gz
  https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz

}

# this script depends on a new unix world of reliable rust tools
poweron_selftest() {
  local required_binaries installed_binaries

  if ! which -s docker || ! docker ps &> /dev/null; then
    echo "Error: ${ONYMA} does not detect a running docker, please install or start docker: brew cask install docker"
    exit 5
  fi

  missing_binaries=()
  required_binaries=(
    rg
    fd
  )

  for cmd in ${required_binaries[@]}; do
    command -v "$cmd" > /dev/null || missing_binaries+=( "$cmd" )
  done

  if [[ ${#missing_binaries[@]} -gt 0 ]]; then
    $ACQUIRE_DEPS_FUNC ${missing_binaries[@]}
  fi
}

memory_bootstrap() {
  local memory_file="${OUR_DIR}/memory"

  [[ -d "$OUR_DIR" ]] || mkdir -p "$OUR_DIR"
  [[ -f "$memory_file" ]] || touch "$memory_file"


}

# This script will keep itself up to date
installer() {
  local init_url="$1"
  local rel_chan="$2"

  if [[ -z "${init_url:-}" ]]; then
    echo "Usage: $0 <initialization_url>"
    exit 1
  fi

  if [[ -z "${rel_chan:-}" ]]; then
    rel_chan="production"
  fi
}
