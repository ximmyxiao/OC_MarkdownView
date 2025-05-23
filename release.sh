#!/bin/bash

# CocoaPods release script with single backup (deleted on success)
# Usage: ./release.sh <version_number>

# Check if version number is provided
if [ -z "$1" ]; then
    echo "Error: Version number is required"
    echo "Usage: $0 <version_number>"
    exit 1
fi

VERSION=$1
PODSPEC_FILE="OC_MarkdownView.podspec"
BACKUP_FILE="${PODSPEC_FILE}.bak"

# Step 0: Find and update podspec version
echo "🔍 Searching for $PODSPEC_FILE..."
if [ ! -f "$PODSPEC_FILE" ]; then
    echo "❌ Error: $PODSPEC_FILE not found in current directory"
    exit 1
fi

echo "🔄 Updating version to $VERSION in $PODSPEC_FILE..."
# Create single backup
cp "$PODSPEC_FILE" "$BACKUP_FILE" || {
    echo "❌ Failed to create backup"
    exit 1
}

# Update version in podspec (macOS和Linux兼容的sed命令)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/$s\.version[[:space:]]*=[[:space:]]*'$[^']*$'$/\1$VERSION\2/" "$PODSPEC_FILE" || {
        echo "❌ Failed to update version in $PODSPEC_FILE"
        exit 1
    }
else
    sed -i "s/$s\.version[[:space:]]*=[[:space:]]*'$[^']*$'$/\1$VERSION\2/" "$PODSPEC_FILE" || {
        echo "❌ Failed to update version in $PODSPEC_FILE"
        exit 1
    }
fi

echo "✅ Successfully updated $PODSPEC_FILE to version $VERSION"

# Step 1: Git add all changes
echo "📦 Adding all changes to git..."
git add . || { 
    echo "❌ git add failed"
    exit 1
}

# Step 2: Git commit with version number
echo "💾 Committing changes..."
git commit -m "$VERSION" || { 
    echo "❌ git commit failed"
    exit 1
}

# Step 3: Git push
echo "🚀 Pushing to remote repository..."
git push || { 
    echo "❌ git push failed"
    exit 1
}

# Step 4: Create and push git tag
echo "🏷️ Creating tag for version $VERSION..."
git tag "$VERSION" || { 
    echo "❌ git tag failed"
    exit 1
}

echo "🏷️ Pushing tags..."
git push --tags || { 
    echo "❌ git push --tags failed"
    exit 1
}

# Step 5: Push to CocoaPods trunk
echo "📦 Pushing $PODSPEC_FILE to CocoaPods trunk..."
pod trunk push "$PODSPEC_FILE" --allow-warnings || { 
    echo "❌ pod trunk push failed"
    echo "⚠️ You may need to run 'pod trunk me' to check your login status"
    exit 1
}

# On success, remove backup
rm "$BACKUP_FILE" && echo "🧹 Backup file removed"

echo ""
echo "🎉 Successfully released version $VERSION!"
echo "✅ All operations completed successfully!"
