#!/vendor/bin/sh

DIR=/data/vendor/dump_touch
LOCKFILE="$DIR"/dumping
LOGFILE="$DIR"/dump.log

if [ ! -f $LOCKFILE ] || [ ! -f $LOGFILE ] || [ "$(cat $LOCKFILE)" = 0 ]
then
	echo "-----------------------------------------------------"
	echo "Info : Touch debug data not found! Backfilling..."
	echo "-----------------------------------------------------"
	/vendor/bin/predump_touch.sh > /dev/null 2>&1
fi

state=$(cat $LOCKFILE)
if [ "$state" != 2 ]
then
  echo "Unexpected state! Expected 2 but found ${state}"
fi

if [ -f $LOGFILE ]
then
	cat $LOGFILE
	echo "" > $LOGFILE
fi

if [ -f $LOCKFILE ]
then
	echo 0 > $LOCKFILE
fi
