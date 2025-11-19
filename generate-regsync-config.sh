
set -e

# Check if target registry is provided
if [ -z "$1" ]; then
    echo "Using environment variable for target registry"
    TARGET_REGISTRY='${REGSYNC_TARGET_REGISTRY}'
else
    TARGET_REGISTRY="$1"
fi

INPUT_FILE="images.txt"
OUTPUT_FILE="regsync-config-generated.yaml"

echo "Generating regsync configuration..."
echo "Input: ${INPUT_FILE}"
echo "Output: ${OUTPUT_FILE}"
echo "Target Registry: ${TARGET_REGISTRY}"
echo ""

# Start generating the config file
cat > "${OUTPUT_FILE}" <<'EOF'
# Regsync Configuration
# Auto-generated from images.txt
# Usage: regsync once -c regsync-config-generated.yaml

version: 1

# Credentials can be set via:
# - Environment variables: REGSYNC_SOURCE_USERNAME / REGSYNC_SOURCE_PASSWORD
# - Docker config: ~/.docker/config.json
# - Or use docker login before running

defaults:
  parallel: 4
  interval: 0  # Run once (use non-zero for continuous sync)
  backup: ""   # No backup

sync:
EOF

# Function to generate target image name from source
generate_target_name() {
    local src_image="$1"

    # Remove digest if present
    local base_image=$(echo "$src_image" | sed 's/@sha256.*//')

    # Extract image name and tag
    local image_name=$(echo "$base_image" | sed 's|.*/||')

    # Handle special cases for pinned images
    if echo "$src_image" | grep -q "@sha256:"; then
        # If it has a digest but no -pinned suffix, add it
        if ! echo "$image_name" | grep -q "pinned"; then
            # Replace last tag with tag-pinned
            image_name=$(echo "$image_name" | sed 's/:/:pinned-/' | sed 's/-pinned-$/-pinned/')
        fi
    fi

    echo "$image_name"
}

# Parse images.txt and generate sync entries
echo "Processing images from ${INPUT_FILE}..."

line_count=0
image_count=0

while IFS= read -r line; do
    ((line_count++))

    # Skip empty lines and comments
    if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi

    # Trim whitespace
    line=$(echo "$line" | xargs)

    # Skip if still empty
    if [[ -z "$line" ]]; then
        continue
    fi

    # Generate target name
    target_name=$(generate_target_name "$line")

    # Write sync entry
    cat >> "${OUTPUT_FILE}" <<EOF

  - source: ${line}
    target: ${TARGET_REGISTRY}/${target_name}
    type: image
EOF

    ((image_count++))
done < <(grep -v '^#' "${INPUT_FILE}" | grep -v '^$')

echo ""
echo "Configuration generated successfully!"
echo "Total images: ${image_count}"
echo "Output file: ${OUTPUT_FILE}"
echo ""
echo "To run the sync:"
echo "  export REGSYNC_TARGET_REGISTRY=your-registry.io/your-namespace"
echo "  regsync once -c ${OUTPUT_FILE}"
echo ""
echo "For dry run (check only):"
echo "  regsync once -c ${OUTPUT_FILE} check"
echo ""
