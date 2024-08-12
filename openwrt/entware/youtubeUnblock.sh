#!/bin/sh

PATH=/opt/sbin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

PIDFILE="/opt/var/run/youtubeunblock.pid"
YTUNBLOCK="/opt/usr/bin/youtubeUnblock 537"

ytb_status()
{
	[ -f $PIDFILE ] && [ -d /proc/`cat $PIDFILE` ]
}

start() {
	if lsmod | grep "xt_connbytes " &> /dev/null ; then
		echo "xt_connbytes.ko is already loaded"
	else 
		if insmod /lib/modules/$(uname -r)/xt_connbytes.ko &> /dev/null ; then
			echo "xt_connbytes.ko loaded"
		else
			echo "Cannot find xt_connbytes.ko kernel module, aborting"
			exit 1
		fi
	fi
	
	if lsmod | grep "xt_NFQUEUE " &> /dev/null ; then
		echo "xt_NFQUEUE.ko is already loaded"
	else
		if insmod /lib/modules/$(uname -r)/xt_NFQUEUE.ko &> /dev/null ; then
			echo "xt_NFQUEUE.ko loaded"
		else
			echo "Cannot find xt_NFQUEUE.ko kernel module, aborting"
			exit 1
		fi
	fi		 
        
	daemonize -p $PIDFILE $YTUNBLOCK
}

stop() {	
	kill `cat $PIDFILE`        
}

case $1 in
  start)
	if ytb_status ; then
		echo "YT Unblock is already running"
	else
		start
	fi
  ;;
  stop)
	if ytb_status ; then
		stop
	else
		echo "YT Unblock is not started"
	fi
  ;;
  restart)
	stop
	sleep 3
	start
  ;;
  status)
	if ytb_status; then
		echo "YT Unblock is started"
	else
		echo "YT Unblock is not started"
	fi
  ;;
  *)
	echo "Usage: $0 {start|stop|restart|status}"
  ;;
esac
