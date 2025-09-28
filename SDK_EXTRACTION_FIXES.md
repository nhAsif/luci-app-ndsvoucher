# SDK Extraction Fixes

## Issues Identified

1. **Incorrect head command syntax**: `head -1n` should be `head -n1` or `head -1`
2. **Tar listing errors**: "tar: stdout: write error" due to pipe issues
3. **SDK directory detection failures**: Multiple methods needed for robust detection
4. **Directory moving issues**: Better handling of pattern matching and fallbacks

## Fixes Implemented

### 1. Fixed head command syntax
**Before:**
```bash
SDK_DIR=$(tar tf ${{ matrix.target.sdk_tar }} | head -1n | cut -d'/' -f1)
```

**After:**
```bash
# Method 1: First entry in archive
SDK_DIR=$(tar tf ${{ matrix.target.sdk_tar }} 2>/dev/null | head -n1 | cut -d'/' -f1 | grep -E "^openwrt-sdk" || true)

# Method 2: If method 1 failed, look for directory entries
if [ -z "$SDK_DIR" ]; then
  SDK_DIR=$(tar tf ${{ matrix.target.sdk_tar }} 2>/dev/null | grep -E "^[^/]+/$" | head -n1 | cut -d'/' -f1 | grep -E "^openwrt-sdk" || true)
fi

# Method 3: If still failed, use pattern matching
if [ -z "$SDK_DIR" ]; then
  SDK_DIR="openwrt-sdk*"  # Use pattern matching as fallback
fi
```

### 2. Fixed tar listing errors
**Before:**
```bash
tar -tvJf ${{ matrix.target.sdk_tar }} | head -10
```

**After:**
```bash
tar -tvJf ${{ matrix.target.sdk_tar }} 2>/dev/null | head -10
```

### 3. Improved SDK directory detection
Now using multiple methods:
1. **First entry in archive**: Extract the first entry and check if it matches the expected pattern
2. **Directory entries search**: Look specifically for directory entries in the archive
3. **Pattern matching fallback**: Use glob patterns as a last resort

Each method has error handling and fallback logic to ensure the SDK directory is properly detected.

### 4. Enhanced directory moving logic
Better handling of:
- **Pattern matching with glob expansion**: Properly handle glob patterns when moving directories
- **Fallback directory detection**: Search for extracted directories if pattern matching fails
- **Error reporting with ls output**: Provide detailed information when directory moving fails
- **Multiple verification steps**: Check that the moved directory exists and contains expected files

## Additional Improvements

1. **File size verification**: Check if downloaded file is reasonably large
2. **Pre-extraction cleanup**: Remove any existing SDK directories
3. **Post-extraction verification**: Check for essential SDK files
4. **Better error messages**: More informative output when things go wrong

## Key Changes

### Directory Detection
```bash
# Method 1: First entry in archive
SDK_DIR=$(tar tf ${{ matrix.target.sdk_tar }} 2>/dev/null | head -n1 | cut -d'/' -f1 | grep -E "^openwrt-sdk" || true)

# Method 2: Directory entries search
if [ -z "$SDK_DIR" ]; then
  SDK_DIR=$(tar tf ${{ matrix.target.sdk_tar }} 2>/dev/null | grep -E "^[^/]+/$" | head -n1 | cut -d'/' -f1 | grep -E "^openwrt-sdk" || true)
fi

# Method 3: Pattern matching fallback
if [ -z "$SDK_DIR" ]; then
  SDK_DIR="openwrt-sdk*"  # Use pattern matching as fallback
fi
```

### Directory Moving
```bash
# Move the SDK directory
echo "Moving SDK directory..."
if ls $SDK_DIR >/dev/null 2>&1; then
  # Pattern matching worked
  mv $SDK_DIR ${{ matrix.target.sdk_dir }}
else
  # Try to find and move the SDK directory
  SDK_EXTRACTED_DIR=$(ls -1d openwrt-sdk* 2>/dev/null | head -n1)
  if [ -n "$SDK_EXTRACTED_DIR" ] && [ -d "$SDK_EXTRACTED_DIR" ]; then
    mv "$SDK_EXTRACTED_DIR" ${{ matrix.target.sdk_dir }}
  else
    echo "Failed to locate extracted SDK directory"
    ls -la | grep openwrt-sdk || echo "No openwrt-sdk directory found"
    exit 1
  fi
fi
```

## Expected Results

These fixes should resolve:
1. The "head: invalid trailing option -- n" error
2. The "tar: stdout: write error" issues
3. The "Could not determine SDK directory name" failures
4. General robustness improvements for SDK handling

The workflow should now successfully:
1. Download the SDK
2. Extract it properly
3. Detect the SDK directory name
4. Move it to the correct location
5. Verify the extraction was successful