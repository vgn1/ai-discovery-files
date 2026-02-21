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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEPENDENCY_MAP="$REPO_ROOT/specs/dependency-map.yaml"
DEPENDENCY_CHECKER="$SCRIPT_DIR/check-dependency-map.py"

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
  if python3 - "$f" > /dev/null 2>&1 <<'PY'
import sys
path = sys.argv[1]
with open(path, "rb") as fh:
    fh.read().decode("utf-8")
PY
  then
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
  WEBSITE=$(grep -m1 "^Website:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Website: *//' || true)
  COUNTRY=$(grep -m1 "^Country:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Country: *//' || true)
  FOUNDED=$(grep -m1 "^Founded:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Founded: *//' || true)
  CONTACT=$(grep -m1 "^Contact:" "$DIR/llms.txt" 2>/dev/null | sed 's/^Contact: *//' || true)

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

  if [ -n "$WEBSITE" ]; then
    pass "llms.txt has Website field"
  else
    fail "llms.txt is missing 'Website:' field"
  fi

  if [ -n "$COUNTRY" ]; then
    pass "llms.txt has Country field"
  else
    fail "llms.txt is missing 'Country:' field"
  fi

  if [ -n "$FOUNDED" ]; then
    pass "llms.txt has Founded field"
  else
    fail "llms.txt is missing 'Founded:' field"
  fi

  if [ -n "$CONTACT" ]; then
    pass "llms.txt has Contact field"
  else
    fail "llms.txt is missing 'Contact:' field"
  fi

  # Check consistency across other txt files
  IDENTITY_FILES=("ai.txt" "developer-ai.txt" "faq-ai.txt" "robots-ai.txt")

  for f in "${IDENTITY_FILES[@]}"; do
    [ -f "$DIR/$f" ] || continue

    file_bname=$(grep -m1 "^Business name:" "$DIR/$f" 2>/dev/null | sed 's/^Business name: *//' || true)
    file_brand=$(grep -m1 "^Brand name:" "$DIR/$f" 2>/dev/null | sed 's/^Brand name: *//' || true)
    file_services=$(grep -m1 "^Services:" "$DIR/$f" 2>/dev/null | sed 's/^Services: *//' || true)
    file_website=$(grep -m1 "^Website:" "$DIR/$f" 2>/dev/null | sed 's/^Website: *//' || true)
    file_country=$(grep -m1 "^Country:" "$DIR/$f" 2>/dev/null | sed 's/^Country: *//' || true)
    file_founded=$(grep -m1 "^Founded:" "$DIR/$f" 2>/dev/null | sed 's/^Founded: *//' || true)
    file_contact=$(grep -m1 "^Contact:" "$DIR/$f" 2>/dev/null | sed 's/^Contact: *//' || true)

    if [ "$file_bname" = "$BUSINESS_NAME" ]; then
      pass "$f Business name matches llms.txt"
    else
      fail "$f Business name differs from llms.txt"
    fi

    if [ "$file_brand" = "$BRAND_NAME" ]; then
      pass "$f Brand name matches llms.txt"
    else
      fail "$f Brand name differs from llms.txt"
    fi

    if [ "$file_services" = "$SERVICES" ]; then
      pass "$f Services matches llms.txt"
    else
      fail "$f Services differs from llms.txt"
    fi

    if [ "$file_website" = "$WEBSITE" ]; then
      pass "$f Website matches llms.txt"
    else
      fail "$f Website differs from llms.txt"
    fi

    if [ "$file_country" = "$COUNTRY" ]; then
      pass "$f Country matches llms.txt"
    else
      fail "$f Country differs from llms.txt"
    fi

    if [ "$file_founded" = "$FOUNDED" ]; then
      pass "$f Founded matches llms.txt"
    else
      fail "$f Founded differs from llms.txt"
    fi

    if [ "$file_contact" = "$CONTACT" ]; then
      pass "$f Contact matches llms.txt"
    else
      fail "$f Contact differs from llms.txt"
    fi
  done

  # brand.txt includes naming identity fields and should align with llms.txt
  if [ -f "$DIR/brand.txt" ]; then
    brand_registered=$(grep -m1 "^\*\*Registered name:\*\*" "$DIR/brand.txt" 2>/dev/null | sed 's/^\*\*Registered name:\*\* *//' || true)
    brand_public=$(grep -m1 "^\*\*Brand name:\*\*" "$DIR/brand.txt" 2>/dev/null | sed 's/^\*\*Brand name:\*\* *//' || true)

    if [ "$brand_registered" = "$BUSINESS_NAME" ]; then
      pass "brand.txt Registered name matches llms.txt Business name"
    else
      fail "brand.txt Registered name differs from llms.txt Business name"
    fi

    if [ "$brand_public" = "$BRAND_NAME" ]; then
      pass "brand.txt Brand name matches llms.txt Brand name"
    else
      fail "brand.txt Brand name differs from llms.txt Brand name"
    fi
  fi

  # ai.json canonicalIdentityBlock should align with llms.txt identity fields
  if [ -f "$DIR/ai.json" ]; then
    ai_fields_file=$(mktemp)
    python3 - "$DIR/ai.json" > "$ai_fields_file" <<'PY'
import json
import sys

keys = ["Business name", "Brand name", "Services", "Website", "Country", "Founded", "Contact"]
try:
    with open(sys.argv[1], encoding="utf-8") as f:
        data = json.load(f)
except Exception:
    for _ in keys:
        print("")
    raise SystemExit(0)

block = data.get("canonicalIdentityBlock", "")
if not isinstance(block, str):
    block = ""
lines = block.splitlines()

for key in keys:
    prefix = f"{key}: "
    value = ""
    for line in lines:
        if line.startswith(prefix):
            value = line[len(prefix):]
            break
    print(value)
PY
    ai_bname=$(sed -n '1p' "$ai_fields_file")
    ai_brand=$(sed -n '2p' "$ai_fields_file")
    ai_services=$(sed -n '3p' "$ai_fields_file")
    ai_website=$(sed -n '4p' "$ai_fields_file")
    ai_country=$(sed -n '5p' "$ai_fields_file")
    ai_founded=$(sed -n '6p' "$ai_fields_file")
    ai_contact=$(sed -n '7p' "$ai_fields_file")
    rm -f "$ai_fields_file"

    if [ "$ai_bname" = "$BUSINESS_NAME" ]; then
      pass "ai.json canonicalIdentityBlock Business name matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Business name differs from llms.txt"
    fi

    if [ "$ai_brand" = "$BRAND_NAME" ]; then
      pass "ai.json canonicalIdentityBlock Brand name matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Brand name differs from llms.txt"
    fi

    if [ "$ai_services" = "$SERVICES" ]; then
      pass "ai.json canonicalIdentityBlock Services matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Services differs from llms.txt"
    fi

    if [ "$ai_website" = "$WEBSITE" ]; then
      pass "ai.json canonicalIdentityBlock Website matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Website differs from llms.txt"
    fi

    if [ "$ai_country" = "$COUNTRY" ]; then
      pass "ai.json canonicalIdentityBlock Country matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Country differs from llms.txt"
    fi

    if [ "$ai_founded" = "$FOUNDED" ]; then
      pass "ai.json canonicalIdentityBlock Founded matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Founded differs from llms.txt"
    fi

    if [ "$ai_contact" = "$CONTACT" ]; then
      pass "ai.json canonicalIdentityBlock Contact matches llms.txt"
    else
      fail "ai.json canonicalIdentityBlock Contact differs from llms.txt"
    fi
  fi
else
  fail "llms.txt not found — cannot check identity consistency"
fi

# ─── Placeholder Check ───────────────────────────────────────

section "Placeholder Check"

PLACEHOLDER_COUNT=$(python3 - "$DIR" <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
count = 0

for pattern in ("*.txt", "*.json", "*.html"):
    for path in root.glob(pattern):
        text = path.read_text(encoding="utf-8", errors="ignore")
        for match in re.finditer(r"\[([^\[\]\n]+)\]", text):
            # Ignore Markdown link/image labels: [label](url)
            if match.end() < len(text) and text[match.end()] == "(":
                continue
            count += 1

print(count)
PY
)

if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then
  if [ "$(basename "$DIR")" = "examples" ]; then
    fail "$PLACEHOLDER_COUNT placeholder(s) found in examples — examples should be fully filled and placeholder-free"
  else
    warn "$PLACEHOLDER_COUNT placeholder(s) found — replace [brackets] with real values before deploying"
  fi
else
  pass "No placeholders detected"
fi

# ─── Dependency Map (First Pass) ─────────────────────────────

section "Dependency Map (First Pass)"

if [ -f "$DEPENDENCY_MAP" ] && [ -f "$DEPENDENCY_CHECKER" ]; then
  dep_results_file=$(mktemp)
  dep_stderr_file=$(mktemp)

  if python3 "$DEPENDENCY_CHECKER" "$DIR" "$DEPENDENCY_MAP" > "$dep_results_file" 2> "$dep_stderr_file"; then
    :
  else
    fail "Dependency map checker execution failed"
  fi

  while IFS=$'\t' read -r dep_level dep_message; do
    [ -n "$dep_level" ] || continue
    case "$dep_level" in
      PASS)
        pass "$dep_message"
        ;;
      FAIL)
        fail "$dep_message"
        ;;
      WARN)
        warn "$dep_message"
        ;;
      INFO)
        echo -e "  ${YELLOW}-${NC} $dep_message"
        ;;
      *)
        warn "Dependency checker emitted unknown level '$dep_level': $dep_message"
        ;;
    esac
  done < "$dep_results_file"

  if [ -s "$dep_stderr_file" ]; then
    warn "Dependency checker wrote diagnostic output to stderr"
  fi

  rm -f "$dep_results_file" "$dep_stderr_file"
else
  warn "Dependency map or checker script missing; skipping dependency-map validation"
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
