#!/usr/bin/env bash
#
# validate.sh — Check AI Discovery Files for common issues
#
# Usage: ./validate.sh [--strict] [directory]
#   --strict: enable deployment-readiness checks (placeholders/defaults become errors)
#   directory: path to the folder containing AI Discovery Files (default: templates/)
#

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/validate.sh [--strict] [directory]

Options:
  --strict      Enable deployment-readiness checks (in addition to structural validation)
  -h, --help    Show this help

Arguments:
  directory     Directory containing AI Discovery Files (default: templates)
EOF
}

STRICT_MODE=0
DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    --strict)
      STRICT_MODE=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      if [ $# -gt 0 ]; then
        DIR="$1"
        shift
      fi
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [ -n "$DIR" ]; then
        echo "Multiple directories provided: '$DIR' and '$1'" >&2
        usage >&2
        exit 2
      fi
      DIR="$1"
      ;;
  esac
  shift
done

if [ -z "$DIR" ]; then
  DIR="templates"
fi

ERRORS=0
WARNINGS=0
READINESS_ERRORS=0
READINESS_WARNINGS=0
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
readiness_fail() { fail "$1"; READINESS_ERRORS=$((READINESS_ERRORS + 1)); }
readiness_warn() { warn "$1"; READINESS_WARNINGS=$((READINESS_WARNINGS + 1)); }
warn_or_fail_strict() {
  if [ "$STRICT_MODE" -eq 1 ]; then
    readiness_fail "$1"
  else
    warn "$1"
  fi
}

section "Mode"
if [ "$STRICT_MODE" -eq 1 ]; then
  echo -e "  ${YELLOW}-${NC} Strict mode enabled (structural + deployment-readiness checks)"
else
  echo -e "  ${YELLOW}-${NC} Default mode (structural/consistency validation)"
fi

# ─── File Existence ───────────────────────────────────────────

section "File Existence"

REQUIRED_FILES=("llms.txt" "llm.txt" "identity.json")
RECOMMENDED_FILES=("ai.txt" "brand.txt" "faq-ai.txt" "llms.html" "ai.json")
OPTIONAL_FILES=("robots-ai.txt")
CONDITIONAL_FILES=("llms-full.txt" "developer-ai.txt")

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

for f in "${CONDITIONAL_FILES[@]}"; do
  if [ -f "$DIR/$f" ]; then
    pass "$f exists"
  else
    echo -e "  ${YELLOW}-${NC} $f not present (conditional)"
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
  IDENTITY_FILES=("llms-full.txt" "ai.txt" "developer-ai.txt" "faq-ai.txt" "robots-ai.txt")

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

# ─── DUNS Number (Optional) ──────────────────────────────────

section "DUNS Number (Optional)"

extract_json_value() {
  local file_path="$1"
  local json_path="$2"
  python3 - "$file_path" "$json_path" <<'PY'
import json
import re
import sys

def parse_path(expr):
    tokens = []
    for part in expr.split("."):
        if not part:
            continue
        m = re.fullmatch(r"([A-Za-z0-9_-]+)(\[[0-9]+\])?", part)
        if not m:
            tokens.append(part)
            continue
        tokens.append(m.group(1))
        if m.group(2):
            tokens.append(int(m.group(2)[1:-1]))
    return tokens

try:
    with open(sys.argv[1], encoding="utf-8") as fh:
        data = json.load(fh)
except Exception:
    print("")
    raise SystemExit(0)

value = data
for token in parse_path(sys.argv[2]):
    if isinstance(token, int):
        if not isinstance(value, list) or token >= len(value):
            print("")
            raise SystemExit(0)
        value = value[token]
    else:
        if not isinstance(value, dict) or token not in value:
            print("")
            raise SystemExit(0)
        value = value[token]

if isinstance(value, (dict, list)):
    print("")
else:
    print(str(value).strip())
PY
}

extract_html_duns() {
  local file_path="$1"
  python3 - "$file_path" <<'PY'
import re
import sys

try:
    text = open(sys.argv[1], encoding="utf-8").read()
except Exception:
    print("")
    raise SystemExit(0)

m = re.search(r"<li>\s*DUNS number:\s*([^<\n]+)\s*</li>", text)
print(m.group(1).strip() if m else "")
PY
}

extract_html_alternate_domains() {
  local file_path="$1"
  python3 - "$file_path" <<'PY'
import re
import sys

try:
    text = open(sys.argv[1], encoding="utf-8").read()
except Exception:
    print("")
    raise SystemExit(0)

m = re.search(r"<li>\s*Alternate domains:\s*([^<\n]+)\s*</li>", text)
print(m.group(1).strip() if m else "")
PY
}

extract_json_string_list() {
  local file_path="$1"
  local json_path="$2"
  python3 - "$file_path" "$json_path" <<'PY'
import json
import re
import sys

def parse_path(expr):
    tokens = []
    for part in expr.split("."):
        if not part:
            continue
        m = re.fullmatch(r"([A-Za-z0-9_-]+)(\[[0-9]+\])?", part)
        if not m:
            tokens.append(part)
            continue
        tokens.append(m.group(1))
        if m.group(2):
            tokens.append(int(m.group(2)[1:-1]))
    return tokens

try:
    with open(sys.argv[1], encoding="utf-8") as fh:
        data = json.load(fh)
except Exception:
    print("")
    raise SystemExit(0)

value = data
for token in parse_path(sys.argv[2]):
    if isinstance(token, int):
        if not isinstance(value, list) or token >= len(value):
            print("")
            raise SystemExit(0)
        value = value[token]
    else:
        if not isinstance(value, dict) or token not in value:
            print("")
            raise SystemExit(0)
        value = value[token]

if not isinstance(value, list):
    print("")
    raise SystemExit(0)

items = []
for item in value:
    if isinstance(item, str):
        stripped = item.strip()
        if stripped:
            items.append(stripped)

print(", ".join(items))
PY
}

is_placeholder_duns() {
  [[ "$1" =~ ^\[[^][]+\]$ ]]
}

check_duns_format() {
  local label="$1"
  local value="$2"
  if [ -z "$value" ]; then
    return 1
  fi
  if is_placeholder_duns "$value"; then
    pass "$label DUNS number placeholder present"
    return 0
  fi
  if [[ "$value" =~ ^[0-9]{9}$ ]]; then
    pass "$label DUNS number format is valid"
  else
    fail "$label DUNS number must be 9 digits"
  fi
  return 0
}

check_duns_match() {
  local label="$1"
  local value="$2"
  local source_value="$3"
  if [ -z "$value" ]; then
    warn "$label DUNS number not present while llms.txt includes one"
    return
  fi
  if [ "$value" = "$source_value" ]; then
    pass "$label DUNS number matches llms.txt"
  else
    fail "$label DUNS number differs from llms.txt"
  fi
}

normalize_url_list() {
  local value="$1"
  python3 - "$value" <<'PY'
import sys

raw = sys.argv[1].strip()
items = []
for part in raw.split(","):
    item = part.strip()
    if not item:
        continue
    if item.startswith("[") and item.endswith("]"):
        item = item[1:-1].strip()
    if item:
        items.append(item)

for item in sorted(set(items)):
    print(item)
PY
}

check_alternate_domains_format() {
  local label="$1"
  local value="$2"
  if [ -z "$value" ]; then
    return 1
  fi

  local result
  result=$(python3 - "$value" <<'PY'
import re
import sys

v = sys.argv[1].strip()
parts = [p.strip() for p in v.split(",") if p.strip()]
if not parts:
    print("invalid")
    raise SystemExit(0)

all_placeholder = True
for part in parts:
    if part.startswith("[") and part.endswith("]"):
      url = part[1:-1].strip()
      if not re.fullmatch(r"https?://[^\s\]]+", url):
          print("invalid")
          raise SystemExit(0)
    else:
      all_placeholder = False
      if not re.fullmatch(r"https?://\S+", part):
          print("invalid")
          raise SystemExit(0)

print("placeholder" if all_placeholder else "valid")
PY
)

  case "$result" in
    placeholder)
      pass "$label alternate domains placeholder list present"
      ;;
    valid)
      pass "$label alternate domains format is valid"
      ;;
    *)
      fail "$label alternate domains must be a comma-separated list of absolute URLs"
      ;;
  esac
  return 0
}

check_alternate_domains_match() {
  local label="$1"
  local value="$2"
  local source_value="$3"
  if [ -z "$value" ]; then
    warn "$label alternate domains not present while llms.txt includes them"
    return
  fi

  local norm_value norm_source
  norm_value=$(normalize_url_list "$value")
  norm_source=$(normalize_url_list "$source_value")
  if [ "$norm_value" = "$norm_source" ]; then
    pass "$label alternate domains match llms.txt"
  else
    fail "$label alternate domains differ from llms.txt"
  fi
}

LLMS_DUNS=""
if [ -f "$DIR/llms.txt" ]; then
  LLMS_DUNS=$(grep -m1 "^- DUNS number:" "$DIR/llms.txt" 2>/dev/null | sed 's/^- DUNS number: *//' || true)
fi

if [ -z "$LLMS_DUNS" ]; then
  echo -e "  ${YELLOW}-${NC} llms.txt DUNS number not present (optional)"
else
  check_duns_format "llms.txt" "$LLMS_DUNS" || true
fi

if [ -f "$DIR/llms-full.txt" ]; then
  llms_full_duns=$(grep -m1 "^- DUNS number:" "$DIR/llms-full.txt" 2>/dev/null | sed 's/^- DUNS number: *//' || true)
  check_duns_format "llms-full.txt" "$llms_full_duns" || true
  if [ -n "$LLMS_DUNS" ]; then
    check_duns_match "llms-full.txt" "$llms_full_duns" "$LLMS_DUNS"
  elif [ -n "$llms_full_duns" ]; then
    warn "llms-full.txt includes DUNS number but llms.txt does not"
  fi
fi

if [ -f "$DIR/llms.html" ]; then
  llms_html_duns=$(extract_html_duns "$DIR/llms.html")
  check_duns_format "llms.html" "$llms_html_duns" || true
  if [ -n "$LLMS_DUNS" ]; then
    check_duns_match "llms.html" "$llms_html_duns" "$LLMS_DUNS"
  elif [ -n "$llms_html_duns" ]; then
    warn "llms.html includes DUNS number but llms.txt does not"
  fi
fi

if [ -f "$DIR/identity.json" ]; then
  identity_json_duns=$(extract_json_value "$DIR/identity.json" "dunsNumber")
  check_duns_format "identity.json" "$identity_json_duns" || true
  if [ -n "$LLMS_DUNS" ]; then
    check_duns_match "identity.json" "$identity_json_duns" "$LLMS_DUNS"
  elif [ -n "$identity_json_duns" ]; then
    warn "identity.json includes dunsNumber but llms.txt does not"
  fi
fi

if [ -f "$DIR/ai.json" ]; then
  ai_json_duns=$(extract_json_value "$DIR/ai.json" "identity.dunsNumber")
  check_duns_format "ai.json identity.dunsNumber" "$ai_json_duns" || true
  if [ -n "$LLMS_DUNS" ]; then
    check_duns_match "ai.json identity.dunsNumber" "$ai_json_duns" "$LLMS_DUNS"
  elif [ -n "$ai_json_duns" ]; then
    warn "ai.json identity.dunsNumber includes a value but llms.txt does not"
  fi
fi

# ─── Alternate Domains (Optional) ────────────────────────────

section "Alternate Domains (Optional)"

LLMS_ALT_DOMAINS=""
if [ -f "$DIR/llms.txt" ]; then
  LLMS_ALT_DOMAINS=$(grep -m1 "^- Alternate domains:" "$DIR/llms.txt" 2>/dev/null | sed 's/^- Alternate domains: *//' || true)
fi

if [ -z "$LLMS_ALT_DOMAINS" ]; then
  echo -e "  ${YELLOW}-${NC} llms.txt alternate domains not present (optional)"
else
  check_alternate_domains_format "llms.txt" "$LLMS_ALT_DOMAINS" || true
fi

if [ -f "$DIR/llms-full.txt" ]; then
  llms_full_alt_domains=$(grep -m1 "^- Alternate domains:" "$DIR/llms-full.txt" 2>/dev/null | sed 's/^- Alternate domains: *//' || true)
  check_alternate_domains_format "llms-full.txt" "$llms_full_alt_domains" || true
  if [ -n "$LLMS_ALT_DOMAINS" ]; then
    check_alternate_domains_match "llms-full.txt" "$llms_full_alt_domains" "$LLMS_ALT_DOMAINS"
  elif [ -n "$llms_full_alt_domains" ]; then
    warn "llms-full.txt includes alternate domains but llms.txt does not"
  fi
fi

if [ -f "$DIR/llms.html" ]; then
  llms_html_alt_domains=$(extract_html_alternate_domains "$DIR/llms.html")
  check_alternate_domains_format "llms.html" "$llms_html_alt_domains" || true
  if [ -n "$LLMS_ALT_DOMAINS" ]; then
    check_alternate_domains_match "llms.html" "$llms_html_alt_domains" "$LLMS_ALT_DOMAINS"
  elif [ -n "$llms_html_alt_domains" ]; then
    warn "llms.html includes alternate domains but llms.txt does not"
  fi
fi

if [ -f "$DIR/identity.json" ]; then
  identity_json_alt_domains=$(extract_json_string_list "$DIR/identity.json" "alternateDomains")
  check_alternate_domains_format "identity.json" "$identity_json_alt_domains" || true
  if [ -n "$LLMS_ALT_DOMAINS" ]; then
    check_alternate_domains_match "identity.json" "$identity_json_alt_domains" "$LLMS_ALT_DOMAINS"
  elif [ -n "$identity_json_alt_domains" ]; then
    warn "identity.json includes alternateDomains but llms.txt does not"
  fi
fi

if [ -f "$DIR/ai.json" ]; then
  ai_json_alt_domains=$(extract_json_string_list "$DIR/ai.json" "identity.alternateDomains")
  check_alternate_domains_format "ai.json identity.alternateDomains" "$ai_json_alt_domains" || true
  if [ -n "$LLMS_ALT_DOMAINS" ]; then
    check_alternate_domains_match "ai.json identity.alternateDomains" "$ai_json_alt_domains" "$LLMS_ALT_DOMAINS"
  elif [ -n "$ai_json_alt_domains" ]; then
    warn "ai.json identity.alternateDomains includes values but llms.txt does not"
  fi
fi

# ─── Default / Dummy Value Check (Strict Mode) ───────────────

section "Default / Dummy Value Check"

if [ "$STRICT_MODE" -eq 0 ]; then
  echo -e "  ${YELLOW}-${NC} Skipped in default mode (use --strict)"
else
  dummy_results_file=$(mktemp)
  python3 - "$DIR" > "$dummy_results_file" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])

def emit(level, msg):
    print(f"{level}\t{msg}")

def read_text(path):
    try:
        return path.read_text(encoding="utf-8")
    except Exception:
        return None

def read_json(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None

def extract_text_line_value(text, prefix):
    for line in text.splitlines():
        if line.startswith(prefix):
            return line[len(prefix):].strip()
    return None

def get_path(data, path_expr):
    cur = data
    for part in path_expr.split("."):
        if cur is None:
            return None
        m = re.fullmatch(r"([A-Za-z0-9_-]+)(\[[0-9]+\])?", part)
        if not m:
            return None
        key = m.group(1)
        if not isinstance(cur, dict) or key not in cur:
            return None
        cur = cur[key]
        if m.group(2):
            idx = int(m.group(2)[1:-1])
            if not isinstance(cur, list) or idx >= len(cur):
                return None
            cur = cur[idx]
    return cur

dummy_patterns = [
    ("yourdomain", re.compile(r"yourdomain\.com", re.I)),
    ("reserved-example-domain", re.compile(r"https?://[^\s\"')>]*\.example(?:\.[A-Za-z0-9-]+)?(?:/|$)", re.I)),
    ("template-email", re.compile(r"\b(?:hello|support)@yourdomain\.com\b", re.I)),
    ("template-phone", re.compile(r"\+1\s*XXX\s*XXX\s*XXXX", re.I)),
    ("n/a", re.compile(r"^\s*N/?A\s*$", re.I)),
    ("tbd", re.compile(r"^\s*TBD\s*$", re.I)),
    ("todo", re.compile(r"^\s*TODO\s*$", re.I)),
    ("dummy-zip", re.compile(r"^\s*0{5}(?:-0{4})?\s*$")),
]

def check_value(label, value):
    if value is None:
        return
    if not isinstance(value, str):
        return
    v = value.strip()
    if v == "":
        emit("FAIL", f"{label} is empty")
        return
    for pattern_name, pattern in dummy_patterns:
        if pattern.search(v):
            emit("FAIL", f"{label} contains obvious default/dummy value ({pattern_name})")
            return

# Text files: check main fields that commonly remain default-ish after generation.
text_targets = [
    ("llms.txt", [
        "Website: ", "Contact: ", "- DUNS number: ", "- Alternate domains: ",
        "- Legal name: ", "- Registration: ", "- Tax ID / VAT: ", "- Registered address: "
    ]),
    ("llms-full.txt", [
        "Website: ", "Contact: ", "- DUNS number: ", "- Alternate domains: "
    ]),
]

for file_name, prefixes in text_targets:
    path = root / file_name
    if not path.exists():
        continue
    text = read_text(path)
    if text is None:
        continue
    for prefix in prefixes:
        value = extract_text_line_value(text, prefix)
        if value is not None:
            check_value(f"{file_name} '{prefix.strip()}'", value)

# JSON files: targeted keys that should be real deploy values when present.
json_targets = {
    "identity.json": [
        "name", "legalName", "url", "dunsNumber", "alternateDomains[0]",
        "headquarters.addressLocality", "headquarters.addressRegion", "headquarters.postalCode",
        "contactPoints[0].email", "contactPoints[0].telephone"
    ],
    "ai.json": [
        "identity.registeredName", "identity.website", "identity.companyRegistration",
        "identity.taxId", "identity.dunsNumber", "identity.alternateDomains[0]",
        "contact.general", "contact.support", "contact.phone",
        "pages.homepage", "aiFiles.llmsTxt"
    ]
}

for file_name, paths in json_targets.items():
    path = root / file_name
    if not path.exists():
        continue
    data = read_json(path)
    if data is None:
        continue
    for path_expr in paths:
        check_value(f"{file_name} {path_expr}", get_path(data, path_expr))
PY

  if [ -s "$dummy_results_file" ]; then
    while IFS=$'\t' read -r check_level check_message; do
      [ -n "$check_level" ] || continue
      case "$check_level" in
        FAIL) readiness_fail "$check_message" ;;
        WARN) readiness_warn "$check_message" ;;
        PASS) pass "$check_message" ;;
        *) readiness_warn "Dummy check emitted unknown level '$check_level': $check_message" ;;
      esac
    done < "$dummy_results_file"
  else
    pass "No obvious default/dummy values detected in checked fields"
  fi
  rm -f "$dummy_results_file"
fi

# ─── llm.txt URL Sanity (Strict Mode) ────────────────────────

section "llm.txt URL Sanity"

if [ "$STRICT_MODE" -eq 0 ]; then
  echo -e "  ${YELLOW}-${NC} Skipped in default mode (use --strict)"
elif [ ! -f "$DIR/llm.txt" ]; then
  echo -e "  ${YELLOW}-${NC} llm.txt not present (checked in File Existence)"
else
  llm_target_url=$(python3 - "$DIR/llm.txt" <<'PY'
import re
import sys

try:
    text = open(sys.argv[1], encoding="utf-8").read()
except Exception:
    print("")
    raise SystemExit(0)

match = re.search(r"\[(https?://[^\]\s]+)\]", text)
if not match:
    match = re.search(r"(https?://[^\s]+)", text)
print(match.group(1).strip() if match else "")
PY
)

  if [ -z "$llm_target_url" ]; then
    readiness_fail "llm.txt does not contain a parseable target URL"
  else
    pass "llm.txt target URL found"
    if [[ "$llm_target_url" != *"/llms.txt" ]]; then
      readiness_fail "llm.txt target URL should point to /llms.txt"
    else
      pass "llm.txt target URL points to /llms.txt"
    fi
    if [[ "$llm_target_url" =~ yourdomain\.com ]]; then
      readiness_fail "llm.txt target URL contains template placeholder domain"
    fi
    if [[ "$llm_target_url" =~ \.example([/:]|$) || "$llm_target_url" =~ \.example\. ]]; then
      readiness_fail "llm.txt target URL uses reserved example domain"
    fi
  fi
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
  elif [ "$STRICT_MODE" -eq 1 ]; then
    readiness_fail "$PLACEHOLDER_COUNT placeholder(s) found — strict mode requires deploy-ready values (no placeholders)"
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

if [ "$STRICT_MODE" -eq 1 ]; then
  if [ "$READINESS_ERRORS" -eq 0 ] && [ "$READINESS_WARNINGS" -eq 0 ]; then
    echo -e "  ${GREEN}Deployment readiness: PASS${NC}"
  elif [ "$READINESS_ERRORS" -eq 0 ]; then
    echo -e "  ${YELLOW}Deployment readiness: WARN ($READINESS_WARNINGS warning(s))${NC}"
  else
    echo -e "  ${RED}Deployment readiness: FAIL ($READINESS_ERRORS error(s), $READINESS_WARNINGS warning(s))${NC}"
  fi
fi

exit "$ERRORS"
