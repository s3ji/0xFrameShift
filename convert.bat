@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Clear output directory
if exist "output\*.*" del /Q output\*.* >nul 2>&1

::Mode (easy, normal, hard, super_hard, ultra_hard, custom, advanced_evasion, optimized)
SET MODE=optimized

::Basic settings
SET FLIP=
SET CLEAR_METADATA=-map_metadata -1
SET TRIM_START="0"
SET RAND_FILENAME=1

::Optimized quality settings
IF %MODE%==optimized (
    SET PRESERVE_ORIGINAL_SIZE=1
    SET QUALITY_PRESET=fast
    SET CRF_VALUE=20
    SET ENABLE_DENOISING=1
    SET ENABLE_SHARPENING=1
    SET ENABLE_UNIQUENESS=1
    SET TWO_PASS_ENCODING=0
    SET AUDIO_QUALITY_HIGH=1
) ELSE (
    SET PRESERVE_ORIGINAL_SIZE=0
    SET QUALITY_PRESET=medium
    SET CRF_VALUE=23
)

::Codec selection - OPTIMIZED FOR SPEED
IF %MODE%==optimized (
    SET VIDEO_CODEC=-c:v libx264 -preset fast -crf 20 -threads 0
    SET AUDIO_CODEC=-c:a aac -b:a 192k -ar 48000
    SET AUDIO_LAYOUT=-ac 2 -channel_layout stereo
) ELSE (
    SET VIDEO_CODEC=-c:v libx264 -preset fast -threads 0
    SET AUDIO_CODEC=-c:a aac -b:a 128k
    SET AUDIO_LAYOUT=-ac 2
)

::PRE-GENERATE ALL RANDOM VALUES IN ONE SHOT (MAJOR SPEED BOOST)
CALL :PreGenerateAllRandomValues

ECHO "Optimized Video Processing - Mode: %MODE% (Speed Optimized)"
ECHO "Quality Settings: Fast preset, CRF=20, All uniqueness features enabled"
ECHO "Processing with pre-generated random values for maximum speed..."

SET FILE_INDEX=0
for %%f in (input\*) do (
    SET /A FILE_INDEX+=1
    SET "INPUT_FILENAME=%%f"
    CALL :ProcessSingleFile "%%f" !FILE_INDEX!
)

ECHO "Processing complete! Files optimized with full uniqueness features."
EXIT /B 0

::OPTIMIZED SINGLE FILE PROCESSING
:ProcessSingleFile
SETLOCAL ENABLEDELAYEDEXPANSION
SET "INPUT_FILE=%~1"
SET "IDX=%~2"

::Use pre-generated random values
SET RAND_RESOLUTION=!RAND_RES_%IDX%!
SET RAND_VOLUME=!RAND_VOL_%IDX%!
SET RAND_GAMMA=!RAND_GAM_%IDX%!
SET RAND_SATURATION=!RAND_SAT_%IDX%!
SET RAND_BRIGHTNESS=!RAND_BRI_%IDX%!
SET RAND_SPEED=!RAND_SPD_%IDX%!
SET RAND_CROP=!RAND_CRP_%IDX%!
SET NOISE_LEVEL=!NOISE_%IDX%!
SET PAD_SIZE=!PAD_SZ_%IDX%!
SET PAD_COLOR=!PAD_COL_%IDX%!
SET AUDIO_LAYOUT_CHOICE=!AUD_LAY_%IDX%!
SET CODEC_CHOICE=!CODEC_%IDX%!

::Set filename
IF %RAND_FILENAME%==1 (
    SET "OUTPUT_FILENAME=!FILENAME_%IDX%!_reel.mp4"
) ELSE (
    for %%x in ("!INPUT_FILE!") do SET "OUTPUT_FILENAME=%%~nx_reel_processed.mp4"
)

::Set codec based on pre-generated choice
IF !CODEC_CHOICE!==1 SET VIDEO_CODEC=-c:v libx264 -preset fast -crf 20 -threads 0
IF !CODEC_CHOICE!==2 SET VIDEO_CODEC=-c:v libx265 -preset fast -crf 20 -tag:v hvc1 -threads 0
IF !CODEC_CHOICE!==3 SET VIDEO_CODEC=-c:v libx264 -preset fast -crf 20 -profile:v high -threads 0

::Build quality-preserving filter chain (STREAMLINED)
IF %PRESERVE_ORIGINAL_SIZE%==1 (
    IF !RAND_RESOLUTION! NEQ 1.00 (
        SET FILTER_CHAIN=scale="ceil(iw*!RAND_RESOLUTION!/2)*2:ceil(ih*!RAND_RESOLUTION!/2)*2":flags=lanczos
    ) ELSE (
        SET FILTER_CHAIN=format=yuv420p
    )
) ELSE (
    SET FILTER_CHAIN=scale="ceil(iw*!RAND_RESOLUTION!/2)*2:ceil(ih*!RAND_RESOLUTION!/2)*2":flags=lanczos
)

::Add quality enhancement filters (LIGHTER FOR SPEED)
IF %ENABLE_DENOISING%==1 (
    SET FILTER_CHAIN=!FILTER_CHAIN!,hqdn3d=2:1:2:1
)

IF %ENABLE_SHARPENING%==1 (
    SET FILTER_CHAIN=!FILTER_CHAIN!,unsharp=3:3:0.3:3:3:0.3
)

::Add color adjustments
SET FILTER_CHAIN=!FILTER_CHAIN!,eq=gamma=!RAND_GAMMA!:saturation=!RAND_SATURATION!:brightness=!RAND_BRIGHTNESS!

::Add temporal adjustments
SET FILTER_CHAIN=!FILTER_CHAIN!,setpts=PTS/!RAND_SPEED!

::Add cropping for uniqueness
SET FILTER_CHAIN=!FILTER_CHAIN!,crop=!RAND_CROP!*in_w:!RAND_CROP!*in_h

::Add uniqueness features
IF %ENABLE_UNIQUENESS%==1 (
    SET FILTER_CHAIN=!FILTER_CHAIN!,noise=alls=!NOISE_LEVEL!:allf=t
    SET FILTER_CHAIN=!FILTER_CHAIN!,pad=iw+!PAD_SIZE!:ih+!PAD_SIZE!:!PAD_SIZE!/2:!PAD_SIZE!/2:0x!PAD_COLOR!
)

::Build audio filter chain with uniqueness
SET "AUDIO_FILTER=volume=!RAND_VOLUME!,atempo=!RAND_SPEED!,highpass=f=50,lowpass=f=15000"

::Add audio uniqueness based on pre-generated choice (SIMPLIFIED FOR RELIABILITY)
IF !AUDIO_LAYOUT_CHOICE!==1 SET "AUDIO_FILTER=!AUDIO_FILTER!,pan=stereo|c0=c0|c1=c1"
IF !AUDIO_LAYOUT_CHOICE!==2 SET "AUDIO_FILTER=!AUDIO_FILTER!,volume=!RAND_VOLUME!"
IF !AUDIO_LAYOUT_CHOICE!==3 SET "AUDIO_FILTER=volume=!RAND_VOLUME!,atempo=!RAND_SPEED!,highpass=f=60,lowpass=f=14000"

::Execute FFmpeg command - OPTIMIZED FLAGS
ffmpeg -hide_banner -loglevel error -i "!INPUT_FILE!" -ss "00:00:%TRIM_START%" ^
       -vf "!FILTER_CHAIN!" ^
       -af "!AUDIO_FILTER!" ^
       %FLIP% ^
       !VIDEO_CODEC! ^
       !AUDIO_CODEC! ^
       !AUDIO_LAYOUT! ^
       %CLEAR_METADATA% ^
       -metadata title="Video-!META_%IDX%!" ^
       -metadata comment="Mobile-!META_%IDX%!" ^
       -metadata description="Content-!META_%IDX%!" ^
       -metadata encoder="ffmpeg!META_%IDX%!" ^
       -movflags +faststart ^
       -y "output\!OUTPUT_FILENAME!"

::ALL UNIQUENESS POST-PROCESSING PRESERVED BUT OPTIMIZED
IF EXIST "output\!OUTPUT_FILENAME!" (
    ::File padding for uniqueness - OPTIMIZED
    fsutil file createnew "output\!OUTPUT_FILENAME!.pad" 1024 >nul 2>&1
    IF EXIST "output\!OUTPUT_FILENAME!.pad" (
        type "output\!OUTPUT_FILENAME!.pad" >> "output\!OUTPUT_FILENAME!" 2>nul
        del "output\!OUTPUT_FILENAME!.pad" 2>nul
    )

    ::Timestamp randomization - PRESERVED
    powershell -Command "(Get-Item 'output\!OUTPUT_FILENAME!').CreationTime=(Get-Date).AddMinutes(!TIME_OFFSET1_%IDX%!); (Get-Item 'output\!OUTPUT_FILENAME!').LastWriteTime=(Get-Date).AddMinutes(!TIME_OFFSET2_%IDX%!)" >nul 2>&1

    ::Alternative container creation - PRESERVED  
    SET CONTAINER_CHOICE=!CONTAINER_%IDX%!
    IF !CONTAINER_CHOICE! LEQ 2 (
        SET ALT_OUTPUT=!ALT_NAME_%IDX%!_reel_alt.mp4
        ffmpeg -hide_banner -loglevel error -i "output\!OUTPUT_FILENAME!" -c copy "output\!ALT_OUTPUT!" >nul 2>&1
    )

    ECHO "Successfully processed: !OUTPUT_FILENAME!"
) ELSE (
    ECHO "ERROR: Failed to process %INPUT_FILE%"
)

ENDLOCAL
EXIT /B 0

::SUPER-OPTIMIZED RANDOM VALUE PRE-GENERATION
:PreGenerateAllRandomValues
SET FILE_COUNT=0
for %%f in (input\*) do SET /a FILE_COUNT+=1

ECHO Pre-generating all random values for %FILE_COUNT% files...

::Generate random values using simpler approach to avoid parsing issues
SET /a IDX=0
for %%f in (input\*) do (
    SET /a IDX+=1
    CALL :GenerateRandomForFile !IDX!
)

ECHO All random values pre-generated successfully!
EXIT /B 0

::Generate random values for single file - RELIABLE METHOD
:GenerateRandomForFile
SET FILE_IDX=%1

::Generate randomization values based on MODE
IF %MODE%==easy (
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "[System.Random]::new().NextDouble() * 0.01"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.995 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==normal (
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.005 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.99 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==hard (
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.02 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.98 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==super_hard (
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.05 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.96 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==ultra_hard (
    for /f %%a in ('powershell -Command "1.10 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.10 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.10 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.10 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.10 + ([System.Random]::new().NextDouble() * 0.05)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.04 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.94 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==advanced_evasion (
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.15)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.10)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.05 + ([System.Random]::new().NextDouble() * 0.10)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.02 + ([System.Random]::new().NextDouble() * 0.08)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.02 + ([System.Random]::new().NextDouble() * 0.10)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.04)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.95 + ([System.Random]::new().NextDouble() * 0.03)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==optimized (
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.02)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "[System.Random]::new().NextDouble() * 0.02"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.00 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.99 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
) ELSE IF %MODE%==custom (
    SET "RAND_RES_%FILE_IDX%=1.10"
    SET "RAND_VOL_%FILE_IDX%=1.20"
    SET "RAND_GAM_%FILE_IDX%=1.20"
    SET "RAND_SAT_%FILE_IDX%=1.20"
    SET "RAND_BRI_%FILE_IDX%=0.20"
    SET "RAND_SPD_%FILE_IDX%=1.08"
    SET "RAND_CRP_%FILE_IDX%=0.90"
) ELSE (
    ::Default to normal if mode not recognized
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_RES_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_VOL_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_GAM_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_SAT_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.01 + ([System.Random]::new().NextDouble() * 0.01)"') do SET "RAND_BRI_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "1.005 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_SPD_%FILE_IDX%=%%a"
    for /f %%a in ('powershell -Command "0.99 + ([System.Random]::new().NextDouble() * 0.005)"') do SET "RAND_CRP_%FILE_IDX%=%%a"
)

::Integer values
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1,6)"') do SET "NOISE_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1,4)"') do SET "PAD_SZ_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(0,16777216).ToString('X6')"') do SET "PAD_COL_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1,4)"') do SET "AUD_LAY_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1,4)"') do SET "CODEC_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(10000,99999)"') do SET "META_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(-999,1000)"') do SET "TIME_OFFSET1_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(-999,1000)"') do SET "TIME_OFFSET2_%FILE_IDX%=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1,11)"') do SET "CONTAINER_%FILE_IDX%=%%a"

::Filename generation
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1000,9999)"') do SET "FNAME_PART1=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1000,9999)"') do SET "FNAME_PART2=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1000,9999)"') do SET "FNAME_PART3=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1000,9999)"') do SET "FNAME_PART4=%%a"
SET "FILENAME_%FILE_IDX%=!FNAME_PART1!!FNAME_PART2!!FNAME_PART3!!FNAME_PART4!"

::Alt filename generation
for /f %%a in ('powershell -Command "[System.Random]::new().Next(1000,9999)"') do SET "ALT_PART1=%%a"
for /f %%a in ('powershell -Command "[System.Random]::new().Next(100,999)"') do SET "ALT_PART2=%%a"
SET "ALT_NAME_%FILE_IDX%=!ALT_PART1!alt!ALT_PART2!"

EXIT /B 0