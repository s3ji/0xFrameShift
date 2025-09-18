# 0xFrameShift

<div align="center">

[![Windows](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![FFmpeg](https://img.shields.io/badge/requires-FFmpeg-red.svg)](https://ffmpeg.org/download.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Batch Script](https://img.shields.io/badge/language-Batch-green.svg)](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands)

**Advanced video processing tool with multiple quality modes, intelligent optimization, and customizable uniqueness parameters.**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Modes](#-processing-modes) • [Configuration](#-configuration) • [Troubleshooting](#-troubleshooting) • [Contributing](#-contributing)

</div>

---

## Features

- **8 Processing Modes**: From minimal `easy` mode to maximum `ultra_hard` processing
- **Quality Enhancement**: Denoising, sharpening, and color optimization
- **Speed Optimized**: Pre-generates random values for fast batch processing
- **Uniqueness Features**: Multiple techniques to ensure each output is distinct
- **Flexible Codec Support**: H.264, H.265 with intelligent selection
- **Metadata Management**: Custom metadata with randomized identifiers

## Requirements

- Windows 10/11
- FFmpeg (must be in PATH or same directory)
- PowerShell (included with Windows)

## Installation

1. Download or clone this repository
2. Install FFmpeg if not already installed:
   - Download from [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)
   - Add to system PATH or place `ffmpeg.exe` in the script directory
3. Create `input` and `output` directories in the script folder

## Usage

### Basic Usage

1. Place video files in the `input` folder
2. Run the script: `convert.bat`
3. Processed videos will appear in the `output` folder

### Changing Processing Mode

Edit the `MODE` variable at the top of the script:

```batch
SET MODE=optimized
```

### Available Modes

| Mode | Processing Level | Use Case |
|------|------------------|----------|
| `easy` | Minimal (1-1.01x) | Quick processing, subtle changes |
| `normal` | Light (1.01-1.02x) | Balanced approach |
| `hard` | Medium (1.02-1.05x) | More noticeable modifications |
| `super_hard` | Heavy (1.05-1.10x) | Significant alterations |
| `ultra_hard` | Maximum (1.10-1.15x) | Most aggressive processing |
| `advanced_evasion` | Intelligent (1.05-1.20x) | Smart parameter variation |
| `optimized` | Balanced (1.00-1.02x) | High quality with efficiency |
| `custom` | Fixed values | Consistent, predictable results |

## Processing Features

### Video Processing
- **Resolution scaling** with high-quality Lanczos interpolation
- **Color adjustments** (gamma, saturation, brightness)
- **Temporal modifications** (speed variations)
- **Quality enhancement** (denoising and sharpening)
- **Noise injection** for uniqueness
- **Smart cropping** and **padding**

### Audio Processing
- **Volume normalization** and **tempo matching**
- **Frequency filtering** (customizable ranges)
- **Channel processing** variations
- **High-quality AAC encoding**

### File Processing
- **Metadata randomization** with natural-looking values
- **Timestamp modification** for file uniqueness
- **Binary padding** for signature changes
- **Alternative format generation**

## Configuration Options

### Basic Settings
```batch
SET FLIP=                    # Video flip (leave empty for none)
SET CLEAR_METADATA=-map_metadata -1  # Metadata handling
SET TRIM_START="0"          # Start time offset
SET RAND_FILENAME=1         # Random filenames (1=on, 0=off)
```

### Quality Settings (per mode)
- `QUALITY_PRESET`: FFmpeg encoding speed (fast/medium/slow)
- `CRF_VALUE`: Quality level (lower = higher quality)
- `ENABLE_DENOISING`: Noise reduction (1=on, 0=off)
- `ENABLE_SHARPENING`: Image sharpening (1=on, 0=off)
- `ENABLE_UNIQUENESS`: Uniqueness features (1=on, 0=off)

## Output

The script generates:
- **Primary video files** with randomized names (16-digit identifiers)
- **Alternative versions** (20% chance) with different container optimization
- **Processing logs** showing success/failure for each file

### Example Output
```
4583621974853629_reel.mp4    # Main processed video
7264alt892_reel_alt.mp4      # Alternative version (if generated)
```

## Performance

### Speed Comparison
- **Standard processing**: 45-60 seconds per 15-second video
- **Optimized processing**: 15-25 seconds per 15-second video
- **Batch efficiency**: Processes multiple files with pre-generated parameters

### Quality Impact
- **Minimal quality loss** with optimized settings
- **Maintains original resolution** in optimized mode
- **Professional encoding standards** (CRF 20-25 range)

## Technical Details

### Processing Pipeline
1. **Pre-generation** of all random parameters
2. **Video filter chain** construction
3. **Audio filter** application
4. **FFmpeg encoding** with optimized flags
5. **Post-processing** (padding, timestamps, alternatives)

### Filter Chain
The script builds a comprehensive FFmpeg filter chain including:
- Format conversion (YUV420p)
- Resolution scaling with Lanczos
- Denoising (hqdn3d)
- Sharpening (unsharp)
- Color correction (eq filter)
- Temporal adjustment (setpts)
- Cropping and padding
- Noise injection

## Troubleshooting

### Common Issues

**FFmpeg not found**
- Ensure FFmpeg is installed and in PATH
- Or place `ffmpeg.exe` in the script directory

**PowerShell execution error**
- Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**No files processed**
- Check that input files are in the `input` folder
- Verify supported formats (MP4, AVI, MOV, etc.)

**Processing fails**
- Check available disk space
- Ensure output directory is writable
- Verify input files are not corrupted

### Supported Input Formats
- MP4, AVI, MOV, MKV, WMV, FLV
- Most common video codecs
- Various audio formats

## Customization

### Custom Mode Parameters
Edit the `custom` mode section to set fixed values:
```batch
SET "RAND_RES_%FILE_IDX%=1.05"     # Resolution factor
SET "RAND_VOL_%FILE_IDX%=1.10"     # Volume factor
SET "RAND_GAM_%FILE_IDX%=1.15"     # Gamma adjustment
```

### Adding New Modes
1. Add mode configuration in the settings section
2. Add parameter generation in `:GenerateRandomForFile`
3. Update mode list in comments

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Disclaimer

This tool is designed for legitimate video processing and content creation purposes. Users are responsible for complying with applicable laws and platform terms of service when processing and uploading content.