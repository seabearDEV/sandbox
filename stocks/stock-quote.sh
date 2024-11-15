#!/bin/bash

# Replace with your API key
API_KEY="csr1gnhr01qhtrfmtcd0csr1gnhr01qhtrfmtcdg"
SYMBOL="AVGO"

# Check if a symbol was provided
if [ -z "$1" ]; then
    echo "Usage: $0 SYMBOL"
    echo "Example: $0 AVGO"
    exit 1
fi

SYMBOL=$(echo "$1" | tr '[:lower:]' '[:upper:]')

# Make the API call and format the output
echo "Stock Quote for ${SYMBOL}"
echo "----------------------------------------"
curl -s "https://finnhub.io/api/v1/quote?symbol=${SYMBOL}&token=${API_KEY}" | \
    TZ="America/Denver" jq '{ 
        "Current Price": .c,
        "Change": .d,
        "Percent Change": (.dp | tostring + "%"),
        "High of Day": .h,
        "Low of Day": .l,
        "Open Price": .o,
        "Previous Close": .pc,
        "Timestamp": (.t | strflocaltime("%Y-%m-%d %I:%M:%S %p MST"))
    }' | \
    sed 's/[{"}]//g' | \
    sed 's/,//g' | \
    sed 's/^  //g'