#!/bin/bash

set -e

# Fetch latest apktool version from GitHub API
echo "[INFO] Fetching latest apktool version from GitHub..."
LATEST_VERSION=$(curl -sL "https://api.github.com/repos/iBotPeaches/Apktool/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')

if [ -z "$LATEST_VERSION" ]; then
    echo "[ERROR] Failed to fetch latest apktool version"
    exit 1
fi

# Remove 'v' prefix if present
VERSION="${LATEST_VERSION#v}"
echo "[INFO] Latest apktool version: $VERSION"

# Check if apktool.jar already exists and is the correct version
if [ -f "apktool.jar" ]; then
    CURRENT_VERSION=$(java -jar apktool.jar -version 2>&1 | head -n1 || echo "unknown")
    echo "[INFO] Current apktool version: $CURRENT_VERSION"

    if echo "$CURRENT_VERSION" | grep -q "$VERSION"; then
        echo "[INFO] apktool $VERSION is already downloaded. Skipping download."
        exit 0
    else
        echo "[INFO] Different version detected. Downloading apktool $VERSION..."
    fi
else
    echo "[INFO] Downloading apktool $VERSION..."
fi

# Download the latest version
DOWNLOAD_URL="https://github.com/iBotPeaches/Apktool/releases/download/${LATEST_VERSION}/apktool_${VERSION}.jar"
echo "[INFO] Download URL: $DOWNLOAD_URL"

curl -sL "$DOWNLOAD_URL" -o apktool.jar

if [ $? -eq 0 ] && [ -f "apktool.jar" ]; then
    echo "[INFO] Successfully downloaded apktool $VERSION"
    java -jar apktool.jar -version
else
    echo "[ERROR] Failed to download apktool"
    exit 1
fi
