#!/bin/bash

###########################################
# 🧹 Delete old local Git branches by age & prefix
#
# 🔧 USAGE:
#   ./delete_old_branches.sh "AGE" ["prefix1 prefix2 ..."]
#
# 👉 Examples:
#   ./delete_old_branches.sh "6 weeks" "feature/ fix/"
#   ./delete_old_branches.sh "2 months"
#
# 🕓 ALLOWED TIME UNITS:
#   day, days
#   week, weeks
#   month, months
#   year, years
#
###########################################

# Check if age input (time) is provided
if [ -z "$1" ]; then
  echo "❌ Error: Time input required (e.g., '4 months')"
  echo "Usage: $0 \"<time>\" [\"prefix1 prefix2 ...\"]"
  echo "Example: $0 \"6 weeks\" \"feature/ fix/\""
  exit 1
fi

AGE_INPUT="$1"
PREFIXES_INPUT="${2:-feature/}"  # Default to 'feature/' if not provided

# Cross-platform date handling
if date -d "1 day ago" +%s >/dev/null 2>&1; then
  cutoff=$(date -d "$AGE_INPUT ago" +%s)
elif date -v -1d +%s >/dev/null 2>&1; then
  NUMBER=$(echo "$AGE_INPUT" | grep -oE '^[0-9]+')
  UNIT=$(echo "$AGE_INPUT" | grep -oE '[a-zA-Z]+$')

  case "$UNIT" in
    day|days)   FLAG="-v -${NUMBER}d" ;;
    week|weeks) FLAG="-v -$((NUMBER * 7))d" ;;
    month|months) FLAG="-v -${NUMBER}m" ;;
    year|years) FLAG="-v -${NUMBER}y" ;;
    *) echo "❌ Unsupported time unit: $UNIT"; exit 1 ;;
  esac

  cutoff=$(eval date $FLAG +%s)
else
  echo "❌ Unsupported OS or date format"; exit 1
fi

if ! [[ "$cutoff" =~ ^[0-9]+$ ]]; then
  echo "❌ Error: Could not compute cutoff timestamp from '$AGE_INPUT'"
  exit 1
fi

# Parse prefixes
IFS=' ' read -r -a PREFIXES <<< "$PREFIXES_INPUT"

# Build grep pattern
PATTERN=""
for prefix in "${PREFIXES[@]}"; do
  if [[ "$prefix" == */ ]]; then
    PATTERN+="^$prefix|"
  else
    PATTERN+="^$prefix$|"
  fi
done
PATTERN=${PATTERN%|}

# Get matching local branches
branches=$(git for-each-ref --format='%(refname:short)' refs/heads | grep -E "$PATTERN")

for branch in $branches; do
  last_commit_date=$(git log -1 --format="%ct" "$branch" 2>/dev/null)

  if ! [[ "$last_commit_date" =~ ^[0-9]+$ ]]; then
    continue
  fi

  if [ "$last_commit_date" -lt "$cutoff" ]; then
    git branch -D "$branch"
  fi
done
