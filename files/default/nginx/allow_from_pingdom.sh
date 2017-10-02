#!/bin/bash
# Copyright Inviqa UK Ltd 2017
# Author: Marco Massari Calderone <mmassari@inviqa.com>
set -eu
# Check that the conf file path is provided.
if [ $# -ne 1 ]; then
    printf "$0 needs 1 parameter that defines the allow_from.conf path.\n"
    exit 1
fi
CURL=$(which curl);
WEBSERVICE="nginx"
ALLOW_FROM_CONF="$1"
IP_LISTS=(
          "https://my.pingdom.com/probes/ipv4"
          "https://my.pingdom.com/probes/ipv6"
          )
ALLOW_FROM_TEMP="/tmp/pingdom-ips.tmp"
INFO="# THIS FILE IS UPDATED BY $(dirname $0)/$0 RUN BY CRON"

# reset the current allow_from conf file
echo $INFO > $ALLOW_FROM_TEMP

# add the list of ips
for LIST in "${IP_LISTS[@]}"
do
  eval "$CURL -s $LIST |sed -e ''/^$/d';s/^/allow /;s/$/;/' >> $ALLOW_FROM_TEMP"
done

# compares the newly generated file with the existing one.
set +e
cmp -s $ALLOW_FROM_TEMP $ALLOW_FROM_CONF
RESULT="$?"
set -e
# if they don't match the existing one is replaced
# and the webservice reloaded
if [ "$RESULT" -ne 0 ]; then
   cp $ALLOW_FROM_TEMP $ALLOW_FROM_CONF
   service $WEBSERVICE reload
fi

rm $ALLOW_FROM_TEMP
