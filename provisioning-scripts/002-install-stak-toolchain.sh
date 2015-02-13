#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Next Thing Co.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# standard include line
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi
if [[ -f "${DIR}/common.sh" ]]; then
  source "${DIR}/common.sh"
else
  echo "Could not load common includes at ${BASH_SOURCE%/*}."
  echo "Exiting..."
  exit 1
fi

# stak toolchain
STAK_TOOLCHAIN_URL="http://stak-images.s3.amazonaws.com/sdk/stak-sdk.tar.bz2"
STAK_TARBALL="${SOURCES}/stak-sdk.tar.bz2"

# setup cross development toolchain
if [ ! -d "${CROSS}" ]; then
  # make sources directory for building
  if [ ! -d "${SOURCES}" ]; then
    log "Creating sources directory: ${SOURCES}"
    mkdir -p ${SOURCES}  2>&1 > /dev/null \
      || error "Error creating sources directory"
    chown -R vagrant:vagrant  ${SOURCES} \
      || error "Error setting permissions on ${SOURCES}"
  fi

  if [[ ! -f ${STAK_TARBALL} ]]; then
    wget -q -P ${STAK_TARBALL%/*} ${STAK_TOOLCHAIN_URL} 2>&1 > /dev/null \
      || error "Could not download stak toolchain!"
  fi
  log "Installing SDK to: ${CROSS}"
  mkdir -p ${CROSS} || error "Error making directory ${CROSS}"
  tar xjf ${STAK_TARBALL} -C /opt --strip-components=1 2>&1 > /dev/null \
    || error "Error installing toolchain"
  chown -R vagrant:vagrant  ${CROSS} \
    || error "Error setting permissions on ${CROSS}"
fi