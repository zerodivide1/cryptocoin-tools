#!/bin/bash
# Waits until a given number of confirmations have been announced for 
# a given transaction.
# Note: Uses blockchain.info API for transaction information
# Usage:
# waitfortx_blockchain.sh <TX_HASH> <CONFIRMATIONS>
#
# Dependencies:
#	curl
#	jq (https://github.com/stedolan/jq)
#
# Author: Sean Payne (https://github.com/zerodivide1)
# Donate: 1GHPpkFZg8U9sVLjGASqDd8YqTHoVDVFgn

TX_HASH=$1
TX_NUM=$2

API=https://blockchain.info

getConfirmations () {
	local api_result=$(curl -s "$API/rawtx/$1" | jq '.block_height')
	if [[ "$api_result" == "null" ]] ; then
		echo 0
	else
		local blockheight=$(curl -s "$API/latestblock" | jq '.height')
		local confirmations=$(expr $blockheight - $api_result + 1)
		echo $confirmations
	fi
}

CONFIRMS=0
while [ $CONFIRMS -lt $TX_NUM ]; do
	CONFIRMS=$(getConfirmations "$TX_HASH")
	echo "Confirmations: $CONFIRMS" 1>&2
	if [ $CONFIRMS -lt $TX_NUM ]; then
		sleep 15
	fi
done

exit 0
