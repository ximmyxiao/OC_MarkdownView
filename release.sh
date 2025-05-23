#!/bin/bash

# CocoaPods release script with guaranteed version replacement
# Usage: ./release.sh <version_number>

# Enable error checking and verbose output
set -e
set -o pipefail

# Check if version number is provided
if [ -z "$1" ]; then
    echo "❌ Error: Version number is required"
    echo "💡 Usage: $0 <version_number>"
    exit 1
fi

VERSION=$1
PODSPEC_FILE="OC_MarkdownView.podspec"
BACKUP_FILE="${PODSPEC_FILE}.bak"

echo "=== Starting release process for version $VERSION ==="

# Step 0: Find and update podspec version
echo "🔍 [Step 0] Locating $PODSPEC_FILE..."
if [ ! -f "$PODSPEC_FILE" ]; then
    echo "❌ Error: $PODSPEC_FILE not found in current directory"
    exit 1
fi

echo "✅ Found $PODSPEC_FILE"
echo "📄 Current version line:"
grep -E "s\.version\s*=" "$PODSPEC_FILE" || true

echo "💾 Creating backup..."
cp "$PODSPEC_FILE" "$BACKUP_FILE"
echo "✅ Backup created: $BACKUP_FILE"

# Function to update version with bulletproof replacement
update_version() {
    echo "🔄 Updating version to $VERSION..."
    
    # Use temp file for safety
    TEMP_FILE=$(mktemp)
    
    # Process each line
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*s\.version[[:space:]]*=[[:space:]]*\'([^\']*)\' ]]; then
            # Preserve original indentation
            INDENT=${line%%s.version*}
            echo "${INDENT}s.version          = '$VERSION'" >> "$TEMP_FILE"
            echo "ℹ️  Modified line: ${INDENT}s.version = '$VERSION'"
        else
            echo "$line" >> "$TEMP_FILE"
        fi
    done < "$PODSPEC_FILE"
    
    # Replace original file
    mv "$TEMP_FILE" "$PODSPEC_FILE"
}

# Execute version update
update_version

# Verify version was updated
echo "🔍 Verifying version update..."
UPDATED_VERSION=$(grep -E "s\.version\s*=" "$PODSPEC_FILE" | sed -E "s/.*'([^']+)'.*/\1/")
if [ "$UPDATED_VERSION" != "$VERSION" ]; then
    echo "❌ Version update failed! Expected '$VERSION', got '$UPDATED_VERSION'"
    echo "🔄 Restoring original file..."
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
fi
echo "✅ Version successfully updated to $VERSION"

# Step 1: Git operations
echo "📦 [Step 1] Staging changes..."
git add . || {
    echo "❌ git add failed"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

echo "💾 Committing changes..."
git commit -m "$VERSION" || {
    echo "❌ git commit failed"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

echo "🚀 Pushing to remote..."
git push || {
    echo "❌ git push failed"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

# Step 2: Tagging
echo "🏷️ Creating tag..."
git tag "$VERSION" || {
    echo "❌ git tag failed"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

echo "📡 Pushing tag..."
git push origin "$VERSION" || {
    echo "❌ git push --tags failed"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

# Step 3: CocoaPods trunk
echo "📦 [Step 3] Publishing to CocoaPods Trunk..."
pod trunk push "$PODSPEC_FILE" --allow-warnings || {
    echo "❌ pod trunk push failed"
    echo "💡 Check your CocoaPods session with: pod trunk me"
    mv "$BACKUP_FILE" "$PODSPEC_FILE"
    exit 1
}

# Cleanup
echo "🧹 Cleaning up..."
rm "$BACKUP_FILE"

echo ""
echo "========================================"
echo "🎉 Successfully released version $VERSION!"
echo "✅ All operations completed successfully"
echo "========================================"
echo "New version line:"
grep -E "s\.version\s*=" "$PODSPEC_FILE"
