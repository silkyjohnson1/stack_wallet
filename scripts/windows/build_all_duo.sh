#!/bin/bash

set -e

../app_config/configure_duo.sh

# Configure Windows for Duo.
sed -i 's/Stack Wallet/Stack Duo/g' ../../windows/runner/Runner.rc

# todo: revisit following at some point

# libepiccash requires old rust
source ../rust_version.sh
set_rust_to_1671

mkdir -p build
(cd ../../crypto_plugins/flutter_libepiccash/scripts/windows && ./build_all.sh )  &
(cd ../../crypto_plugins/flutter_liblelantus/scripts/windows && ./build_all.sh ) &
(cd ../../crypto_plugins/flutter_libmonero/scripts/windows && ./build_all.sh)
set_rust_to_1720
(cd ../../crypto_plugins/frostdart/scripts/windows && ./build_all.sh ) &

./build_secp256k1_wsl.sh

wait
echo "Done building"
