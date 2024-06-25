#!/bin/bash

# <xbar.title>Disable Technitium DNS Ad Blocking</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>sshanky</xbar.author>
# <xbar.author.github>sshanky</xbar.author.github>
# <xbar.desc>Temporarily disables Technitium DNS ad blocking, shows a notification, and clears local DNS cache.</xbar.desc>
# <xbar.image>http://www.hosted-somewhere/pluginimage</xbar.image>
# <xbar.dependencies>bash,curl,osascript</xbar.dependencies>
# <xbar.abouturl>https://github.com/TechnitiumSoftware/DnsServer/blob/master/APIDOCS.md</xbar.abouturl>

# Configuration
server_url="http://192.168.13.201:5380"
token="a2e25f22e0d4ec0869bee7093bc3573216fff5ca00dd191948ac91c285052213"
api_url="${server_url}/api/settings"
disable_api_url="${api_url}/temporaryDisableBlocking?token=${token}"
status_api_url="${api_url}/get?token=${token}"

# Function to disable ad blocking
disable_blocking() {
  local minutes=$1
  local disable_url="${disable_api_url}&minutes=${minutes}"

  # Send request to disable ad blocking
  local response=$(curl -s -o /dev/null -w "%{http_code}" "$disable_url")
  echo "Disable blocking response code: $response" 1>&2

  if [ "$response" -eq 200 ]; then
    osascript -e "display notification \"Ad blocking disabled for $minutes minutes.\" with title \"Technitium DNS\""
  else
    osascript -e "display notification \"Failed to disable ad blocking. HTTP status code: $response\" with title \"Technitium DNS\""
  fi
}

# Function to enable ad blocking
enable_blocking() {
  local enable_url="${disable_api_url}&minutes=0"

  # Send request to enable ad blocking
  local response=$(curl -s -o /dev/null -w "%{http_code}" "$enable_url")
  echo "Enable blocking response code: $response" 1>&2

  if [ "$response" -eq 200 ]; then
    osascript -e "display notification \"Ad blocking reactivated.\" with title \"Technitium DNS\""
  else
    osascript -e "display notification \"Failed to reactivate ad blocking. HTTP status code: $response\" with title \"Technitium DNS\""
  fi
}

# Function to clear DNS cache
clear_dns_cache() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  osascript -e "display notification \"Local DNS cache cleared.\" with title \"DNS Cache\""
}

# Function to get remaining time for ad blocking re-enabling
get_remaining_time() {
  local response=$(curl -s "$status_api_url")
  local enable_blocking=$(echo "$response" | grep -o '"enableBlocking":true')

  if [ -n "$enable_blocking" ]; then
    echo "🛑"
  else
    local disable_until=$(echo "$response" | grep -o '"temporaryDisableBlockingTill":"[^"]*' | grep -o '[^"]*$')

    if [ -n "$disable_until" ]; then
      local disable_until_clean=$(echo "$disable_until" | cut -d'.' -f1)
      local current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
      local disable_until_epoch=$(date -jf "%Y-%m-%dT%H:%M:%S" "$disable_until_clean" +"%s")
      local current_time_epoch=$(date -jf "%Y-%m-%dT%H:%M:%S" "$current_time" +"%s")
      local remaining_seconds=$((disable_until_epoch - current_time_epoch))
      local remaining_minutes=$(( (remaining_seconds + 59) / 60 ))  # Round up to the next minute

      echo "Remaining seconds: $remaining_seconds" 1>&2
      echo "Remaining minutes: $remaining_minutes" 1>&2

      if [ "$remaining_minutes" -gt 0 ]; then
        echo "🟢 $remaining_minutes min left | color=green"
      else
        echo "🛑"
      fi
    else
      echo "🛑"
    fi
  fi
}

# Main menu
get_remaining_time
echo "---"
echo "Disable blocklist for 1 minute | bash='$0' param1=1 terminal=false refresh=true"
echo "Disable blocklist for 2 minutes | bash='$0' param1=2 terminal=false refresh=true"
echo "Disable blocklist for 5 minutes | bash='$0' param1=5 terminal=false refresh=true"
echo "Disable blocklist for 10 minutes | bash='$0' param1=10 terminal=false refresh=true"
echo "Disable blocklist for 30 minutes | bash='$0' param1=30 terminal=false refresh=true"
echo "Disable blocklist for 1 hour | bash='$0' param1=60 terminal=false refresh=true"
echo "Disable blocklist for 2 hours | bash='$0' param1=120 terminal=false refresh=true"
echo "Reactivate blocklist | bash='$0' param1=enable terminal=false refresh=true"
echo "---"
echo "Clear local DNS cache | bash='$0' param1=cleardns terminal=false refresh=true"

# Check if a parameter is passed to the script
if [ -n "$1" ]; then
  if [ "$1" == "enable" ]; then
    enable_blocking
  elif [ "$1" == "cleardns" ]; then
    clear_dns_cache
  else
    disable_blocking "$1"
  fi
  exit
fi
