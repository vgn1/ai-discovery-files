#!/usr/bin/env bash
#
# validate.sh — Check AI Discovery Files for common issues
#
# Usage: ./validate.sh [directory]
#   directory: path to the folder containing AI Discovery Files (default: templates/)
#

set -euo pipefail

DIR="${1:-templates}"
ERRORS=0
WARNINGS=0

# Colors (disable if not a terminal)
if [ -t 1 ]; then
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  GREEN='\033[0;32m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  RED='' YELLOW='' GREEN='' BOLD='' NC=''
fi

pass()    { echo -e "  ${GREEN}✓${NC} $1"; }
fail()    { echo -e "  ${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
section() { echo -e "\n${BOLD}$1${NC}"; }

# ─── File Existence ───────────────────────────────────────────

section "File Existence"

REQUIRED_FILES=("llms.txt" "identity.json")
RECOMMENDED_FILES=("llm.txt" "ai.txt" "brand.txt" "faq-ai.txt" "llms.html" "ai.json")
OPTIONAL_FILES=("robots-ai.txt" "developer-ai.txt")

for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$DIR/$f" ]; then
    pass "$f exists"
  else
    fail "$f is missing (required)"
  fi
done

for f in "${RECOMMENDED_FILES[@]}"; do
  if [ -f "$DIR/$f" ]; then
    pass "$f exists"
  else
    warn "$f is missing (recommended)"
  fi
done

for f in "${OPTIONAL_FILES[@]}"; do
  if [ -f "$DIR/$f" ]; then
    pass "$f exists"
  else
    echo -e "  ${YELLOW}-${NC} $f not present (optional)"
  fi
done

# ─── JSON Validation ─────────────────────────────────────────

section "JSON Validation"

for f in identity.json ai.json; do
  if [ -f "$DIR/$f" ]; then
    if python3 -m json.tool "$DIR/$f" > /dev/null 2>&1; then
      pass "$f is valid JSON"
    else
      fail "$f has JSON syntax errors"
    fi
  fi
done

# ─── UTF-8 Encoding ──────────────────────────────────────────

section "Encoding"

for f in "$DIR"/*.txt "$DIR"/*.json "$DIR"/*.html; do
  [ -f "$f" ] || continue
  basename=$(basename "$f")
  if file "$f" | grep -qi "utf-8\|ascii\|unicode"; then
    pass "$basename is UTF-8 compatible"
  else
    warn "$basename may not be UTF-8 encoded"
  fi
done

# ─── Core Identity Consistency ────────────────────────────────

section "Core Identity Consistency"

# Extract identity fields from llms.txt as the source of truth
if [ -f "$DIR/llms.txt" ]; then
  BUSINESS_NAME=$(grep -m1 "^Business name:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Business name: *//' || true)
  BRAND_NAME=$(grep -m1 "^Brand name:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Brand name: *//' || true)
  SERVICES=$(grep -m1 "^Services:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Services: *//' || true)

  if [ -n "$BUSINESS_NAME" ]; then
    pass "llms.txt has Business name: $BUSINESS_NAME"
  else
    fail "llms.txt is missing 'Business name:' field"
  fi

  if [ -n "$BRAND_NAME" ]; then
    pass "llms.txt has Brand name: $BRAND_NAME"
  else
    fail "llms.txt is missing 'Brand name:' field"
  fi

  if [ -n "$SERVICES" ]; then
    pass "llms.txt has Services field"
  else
    fail "llms.txt is missing 'Services:' field"
  fi

  # Check consistency across other txt files
  IDENTITY_FILES=("ai.txt" "developer-ai.txt" "faq-ai.txt" "robots-ai.txt")

  for f in "${IDENTITY_FILES[@]}"; do
    [ -f "$DIR/$f" ] || continue

    file_bname=$(grep -m1 "^Business name:" "$DIR/$f" 2>/dev/null | sed 's/^Business name: *//' || true)
    file_brand=$(grep -m1 "^Brand name:" "$DIR/$f" 2>/dev/null | sed 's/^Brand name: *//' || true)
    file_services=$(grep -m1 "^Services:" "$DIR/$f" 2>/dev/null | sed 's/^Services: *//' || true)

    if [ -n "$BUSINESS_NAME" ] && [ "$file_bname" = "$BUSINESS_NAME" ]; then
      pass "$f Business name matches llms.txt"
    elif [ -n "$file_bname" ]; then
      fail "$f Business name differs from llms.txt"
    fi

    if [ -n "$BRAND_NAME" ] && [ "$file_brand" = "$BRAND_NAME" ]; then
      pass "$f Brand name matches llms.txt"
    elif [ -n "$file_brand" ]; then
      fail "$f Brand name differs from llms.txt"
    fi

    if [ -n "$SERVICES" ] && [ "$file_services" = "$SERVICES" ]; then
      pass "$f Services matches llms.txt"
    elif [ -n "$file_services" ]; then
      fail "$f Services differs from llms.txt"
    fi
  done
else
  fail "llms.txt not found — cannot check identity consistency"
fi

# ─── Placeholder Check ───────────────────────────────────────

section "Placeholder Check"

PLACEHOLDER_COUNT=0
for f in "$DIR"/*.txt "$DIR"/*.json "$DIR"/*.html; do
  [ -f "$f" ] || continue
  count=$(grep -c '\[.*\]' "$f" 2>/dev/null || true)
  if [ "$count" -gt 0 ]; then
    PLACEHOLDER_COUNT=$((PLACEHOLDER_COUNT + count))
  fi
done

if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then
  warn "$PLACEHOLDER_COUNT placeholder(s) found — replace [brackets] with real values before deploying"
else
  pass "No placeholders detected"
fi

# ─── Summary ─────────────────────────────────────────────────

section "Summary"

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "  ${GREEN}All checks passed!${NC}"
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "  ${YELLOW}$WARNINGS warning(s), no errors${NC}"
else
  echo -e "  ${RED}$ERRORS error(s), $WARNINGS warning(s)${NC}"
fi

exit "$ERRORS"
