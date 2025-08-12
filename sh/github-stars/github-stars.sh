#!/bin/bash

# Colors and formatting
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to fetch stars
get_stars() {
    local repo=$1
    local stars=$(curl -s -H "Accept: application/vnd.github.v3+json" \
                      -H "User-Agent: StarCounter" \
                      "https://api.github.com/repos/$repo" | \
                 jq -r '.stargazers_count')
    echo $stars
}

# Print header
echo -e "\n${YELLOW}${BOLD}📊 GitHub Stars Counter${NC}\n"

# Print table header
printf "${BOLD}%-15s %s${NC}\n" "Framework" "Stars"
printf "%-15s %s\n" "----------------" "----------------"

# Fetch and display stars for each framework
frameworks=(
    "React:facebook/react"
    "Angular:angular/angular"
    "Svelte:sveltejs/svelte"
    "Vue:vuejs/core"
    "SolidJS:solidjs/solid"
)

for framework in "${frameworks[@]}"; do
    name="${framework%%:*}"
    repo="${framework#*:}"
    stars=$(get_stars "$repo")

    printf "${CYAN}%-15s${NC} ${GREEN}⭐ %d${NC}\n" "$name" "$stars"

    # Small delay to be nice to GitHub API
    sleep 0.5
done

echo # Empty line at the end
