#Requires -Version 5.1
<#
.SYNOPSIS
    Rasterize the SVG sources into the PNG assets that iOS and social
    link-preview scrapers require.

.DESCRIPTION
    Windows equivalent of generate-icons.sh. Auto-detects an SVG rasterizer
    in order of preference: ImageMagick (magick), Inkscape, Python+cairosvg.

.EXAMPLE
    pwsh scripts/generate-icons.ps1
    powershell scripts/generate-icons.ps1
#>

$ErrorActionPreference = 'Stop'
$root   = Split-Path $PSScriptRoot -Parent
$assets = Join-Path $root 'assets'

# --- tool detection -----------------------------------------------------------

function Test-Command ($name) {
    $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Test-CairoSvg {
    try { & python -c 'import cairosvg' 2>$null; $LASTEXITCODE -eq 0 } catch { $false }
}

function Find-Magick {
    if (Test-Command 'magick') { return 'magick' }
    $candidate = Get-ChildItem 'C:\Program Files\ImageMagick*\magick.exe' -ErrorAction SilentlyContinue |
                 Select-Object -First 1 -ExpandProperty FullName
    if ($candidate) { return $candidate }
    return $null
}

$script:magickExe = Find-Magick
$tool = $null
if ($script:magickExe)       { $tool = 'magick' }
elseif (Test-Command 'inkscape') { $tool = 'inkscape' }
elseif ((Test-Command 'python') -and (Test-CairoSvg)) { $tool = 'cairosvg' }

if (-not $tool) {
    Write-Error @"
ERROR: No SVG rasterizer found.
Install one of:
  winget install ImageMagick.ImageMagick
  winget install Inkscape.Inkscape
  pip install cairosvg
Then re-run this script.
"@
    exit 1
}

Write-Host "Using: $tool"

# --- rasterize ----------------------------------------------------------------

function Rasterize ($src, $dst, $w, $h) {
    $srcAbs = Join-Path $assets $src
    $dstAbs = Join-Path $assets $dst

    switch ($tool) {
        'magick' {
            & $script:magickExe -background none -density 384 $srcAbs -resize "${w}x${h}" $dstAbs
        }
        'inkscape' {
            & inkscape $srcAbs --export-type=png --export-filename=$dstAbs -w $w -h $h 2>$null
        }
        'cairosvg' {
            & python -c @"
import cairosvg
cairosvg.svg2png(url=r'$srcAbs', write_to=r'$dstAbs', output_width=$w, output_height=$h)
"@
        }
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate $dst"
        exit 1
    }

    Write-Host "  v $dst (${w}x${h})"
}

# --- conversions --------------------------------------------------------------

Write-Host "Generating raster icons + OG image..."

Rasterize 'icon.svg'     'apple-touch-icon.png'  180 180
Rasterize 'icon.svg'     'icon-192.png'           192 192
Rasterize 'icon.svg'     'icon-512.png'           512 512
Rasterize 'icon.svg'     'maskable-512.png'       512 512
Rasterize 'favicon.svg'  'favicon-32.png'          32  32
Rasterize 'favicon.svg'  'favicon-180.png'        180 180
Rasterize 'og-image.svg' 'og-image.png'          1200 630

Write-Host "Done. Commit the generated *.png files in assets/."
