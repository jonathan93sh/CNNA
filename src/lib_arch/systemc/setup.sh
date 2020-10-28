#!/bin/bash -e

if [ -f ~/.build/systemc-2.3.3/.build ]
then
	echo "[SystemC-2.3.3: ok]"
	exit 0
fi
echo "[SystemC-2.3.3: not installed]"
mkdir ~/.build/ || echo ok
tar xvzf systemc-2.3.3.tar.gz -C ~/.build/
OLDPATH=$(pwd)
cd ~/.build/systemc-2.3.3/
mkdir objdir || echo ok
mkdir -p ~/.build/bin/systemc-2.3.3 || echo ok
cd objdir
../configure --enable-debug --enable-pthreads --prefix=/usr/local/systemc-2.3.3
#--prefix=~/.build/bin/systemc-2.3.3
sudo make -j8
sudo make check -j8
sudo make install -j8
touch ~/.build/systemc-2.3.3/.build
echo "[SystemC-2.3.3: ok]"
cd $OLDPATH



