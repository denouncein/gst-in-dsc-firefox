#!/bin/bash
set -x

P11_MODEL_NAME=WD_eMudhra_3.4.3

JAVATOOL_NAME=watchsafe_eMudhra_3.4.3

DAEMON_NAME=pcscd_wd

PCSCLITE_LIB_NAME=libpcsclite_wd

PKCS_LIB_NAME=libwdpkcs_eMudhra_343.so

SYSLONGBIT=64bit

DDIR_WD=/usr/lib/WatchData

DDIR_PCSC=$DDIR_WD/pcsc

DDIR_SAFE=$DDIR_WD/eMudhra_3.4.3

DDIR_CERT=$DDIR_SAFE/cert

DDIR_LIB=$DDIR_SAFE/lib

DDIR_BIN=$DDIR_SAFE/bin

DDIR_TOOLS=$DDIR_SAFE/tools

DDIR_DESKTOP=$DDIR_SAFE/desktop

APP_START_DIR=/usr/share/applications

SERV_SCR=

SCR_NAME=

PackPath=

ReleaseInfo=

BIN_getconf='/usr/bin/getconf'

ErrFail() {
	echo ''
	echo '	install failed.'
	echo ''
	exit -1
}

ReleaseInfo='Debian'

CopyFile () {

	mkdir -p $DDIR_SAFE

	if [ -d $DDIR_SAFE ]; then
		echo -n
	else
		ErrFail
	fi


	mkdir -p $DDIR_PCSC
	cp -fpR $PackPath/pcsc/$SYSLONGBIT/* $DDIR_PCSC
	chmod -R a+x $DDIR_PCSC


	mkdir -p $DDIR_LIB
	cp -fpR $PackPath/lib/$SYSLONGBIT/* $DDIR_LIB
	chmod -R a+x $DDIR_LIB


	mkdir -p $DDIR_DESKTOP
	cp -fpR $PackPath/desktop/* $DDIR_DESKTOP


	mkdir -p $DDIR_CERT
	cp -fpR $PackPath/cert/* $DDIR_CERT


	mkdir -p $DDIR_BIN
	cp -fpR $PackPath/bin/$SYSLONGBIT/* $DDIR_BIN
	chmod -R a+x $DDIR_BIN


	mkdir -p $DDIR_TOOLS
	cp -fpR $PackPath/tools/* $DDIR_TOOLS
	chmod -R a+x $DDIR_TOOLS


#	ln -sf $DDIR_PCSC/$DAEMON_NAME /usr/sbin/$DAEMON_NAME
#	ln -sf $DDIR_PCSC/$DAEMON_NAME /sbin/$DAEMON_NAME
	ln -sf $DDIR_PCSC/$PCSCLITE_LIB_NAME.so.1.0.0 $DDIR_PCSC/$PCSCLITE_LIB_NAME.so.1


	ln -sf $DDIR_LIB/libpkcs11wrapper.so $DDIR_TOOLS/libpkcs11wrapper.so


	ln -sf $DDIR_DESKTOP/wdtokentool.desktop $APP_START_DIR/$JAVATOOL_NAME.desktop
	ln -sf $DDIR_TOOLS/tool.sh /usr/bin/$JAVATOOL_NAME
}

InstallSrv() {
	cp -f $PackPath/srv/$SCR_NAME $SERV_SCR
	chmod a+x $SERV_SCR
	echo "	using chkconfig ..."
	rc-update add $DAEMON_NAME
}


# Begin Now !

echo ''
echo "	begin to install $DAEMON_NAME of WatchData ..."
echo ''

PackPath=$(dirname $0)

echo '	copy files ...'
CopyFile

echo "	install $DAEMON_NAME service ..."
SERV_SCR=/etc/init.d/$DAEMON_NAME
SCR_NAME=Debian
InstallSrv

echo "	launch $DAEMON_NAME service..."
service $DAEMON_NAME start

sleep 02s

$DDIR_BIN/P11ModelTool -addP11 $P11_MODEL_NAME $DDIR_LIB/$PKCS_LIB_NAME -allUsers

$DDIR_BIN/P11ModelTool -addCert $DDIR_CERT/eMudhra.p7b -allUsers
#$DDIR_BIN/P11ModelTool -addCert $DDIR_CERT/sub.cer -allUsers

#cp -f $PackPath/uninstall $DDIR_SAFE
#chmod a+x $DDIR_SAFE/uninstall

echo ''
echo '	install completed.'
echo ''

exit 0
