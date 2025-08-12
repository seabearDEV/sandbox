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

# Make the API call for quote data
QUOTE_DATA=$(curl -s "https://finnhub.io/api/v1/quote?symbol=${SYMBOL}&token=${API_KEY}")

# Make the API call for company profile data (includes market cap)
PROFILE_DATA=$(curl -s "https://finnhub.io/api/v1/stock/profile2?symbol=${SYMBOL}&token=${API_KEY}")

# Extract and format market cap
MARKET_CAP=$(echo "$PROFILE_DATA" | jq '.marketCapitalization')

# Format market cap for display (convert to billions/millions as appropriate)
if (( $(echo "$MARKET_CAP > 1000" | bc -l) )); then
    FORMATTED_MCAP=$(echo "$MARKET_CAP / 1000" | bc -l | xargs printf "%.2f B")
else
    FORMATTED_MCAP=$(echo "$MARKET_CAP" | bc -l | xargs printf "%.2f M")
fi

# Display the output
echo "Stock Quote for ${SYMBOL}"
echo "----------------------------------------"
echo "$QUOTE_DATA" | \
    TZ="America/Denver" jq --arg mcap "$FORMATTED_MCAP" '{ 
        "Current Price": .c,
        "Change": .d,
        "Percent Change": (.dp | tostring + "%"),
        "High of Day": .h,
        "Low of Day": .l,
        "Open Price": .o,
        "Previous Close": .pc,
        "Market Cap": $mcap,
        "Timestamp": (.t | strflocaltime("%Y-%m-%d %I:%M:%S %p MST"))
    }' | \
    sed 's/[{"}]//g' | \
    sed 's/,//g' | \
    sed 's/^  //g'