#!/bin/bash

# Get the current date and time of the latest commit in the format yyyymmddHHMMSS
commit_timestamp=$(git log -1 --format="%cd" --date=format:"%Y%m%d%H%M%S")

# Extract components
commit_date=${commit_timestamp:0:8}
commit_hour=${commit_timestamp:8:2}
commit_minute=${commit_timestamp:10:2}
commit_second=${commit_timestamp:12:2}

# Subtract 2 hours manually
adjusted_hour=$((10#$commit_hour - 2))

# Handle potential day rollover
if [ $adjusted_hour -lt 0 ]; then
    adjusted_hour=$((adjusted_hour + 24))
    commit_date=$(date -d "${commit_date} -1 day" +"%Y%m%d")
fi

# Format adjusted hour to two digits
adjusted_hour=$(printf "%02d" $adjusted_hour)

# Combine back into the adjusted timestamp
adjusted_timestamp="${commit_date}${adjusted_hour}${commit_minute}${commit_second}"

# Get the full commit hash of the latest commit (HEAD) and then truncate it to the first 12 characters
commit_hash=$(git log -1 --format="%H" | cut -c1-12)

# Combine to form the pseudo-version
pseudo_version="v0.0.0-${adjusted_timestamp}-${commit_hash}"

# Output the pseudo-version
echo $pseudo_version
