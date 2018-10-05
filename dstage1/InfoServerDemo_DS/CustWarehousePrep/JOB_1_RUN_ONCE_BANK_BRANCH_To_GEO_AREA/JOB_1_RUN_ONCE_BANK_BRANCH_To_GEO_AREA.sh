#!/bin/sh
# Shell script for Datastage to execute an osh script, generated at 2018-10-05 23:34:19
# Compiler runtime stamp 11.7///60/C
#
# Parameters:
# $1 - Run indicator: R=normal run, P=performance wrappered run
# $2 - Environment variable file name - dummy
# $3... - Osh / performance checker command line arguments
RunIndicator=$1
DummyEnv=$2
shift
shift
if test ! -x "$APT_ORCHHOME/bin/osh"
  then echo '##OSHRETVAL NOOSH'
  exit 1
fi
# Test for resource estimation option.
if test $RunIndicator = P
  then $APT_ORCHHOME/bin/orchresest "$@" 2>&1 &
  else $APT_ORCHHOME/bin/osh "$@" 2>&1 &
fi
oshpid=$!
# Write the pid of the conductor process
echo '##OSHPID' $oshpid
wait $oshpid
oshcode=$?
oshdir=`dirname $0`
# Write the terminating string
echo '##OSHRETVAL' $oshcode > $oshdir/../RT_SCTEMP/$oshpid.retval
echo '##OSHRETVAL' $oshcode
# end of script
