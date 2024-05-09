mkdir -p build
cd build
git clone https://github.com/bitcoin-core/secp256k1
cd secp256k1
mkdir -p build && cd build
cmake ..
cmake --build .
mkdir -p ../../../../../build
cp src/libsecp256k1.so.2.2.1 "../../../../../build/libsecp256k1.so"
cd ../../../
