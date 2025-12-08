# .\keymap-drawer\draw_keymap_local.ps1 -TargetKeymap nuke_pad
param(
    [string]$TargetKeymap  # optional
)

# Select keymap files
if ($TargetKeymap) {
    $keymapFiles = Get-ChildItem -Path "config" `
                                 -Filter "$TargetKeymap.keymap" `
                                 -ErrorAction SilentlyContinue

    # if (-not $keymapFiles) {
    #     Write-Warning "Target keymap '$TargetKeymap' not found."
    #     exit 1
    # }
}
else {
    $keymapFiles = Get-ChildItem -Path "config" -Filter "*.keymap"
}

foreach ($keymap in $keymapFiles) {

    $base    = [IO.Path]::GetFileNameWithoutExtension($keymap.Name)
    $yamlOut = "keymap-drawer/svg/$base.yaml"
    $svgOut  = "keymap-drawer/svg/$base.svg"

    # parse keymaps
    try {
        $parseOut = keymap -c "keymap-drawer/keymap_drawer.config.yaml" `
                           parse `
                           -z $keymap.FullName 2>&1

        if ($LASTEXITCODE -ne 0) { throw "Parse failed" }

        $parseOut | Out-File $yamlOut -Encoding utf8
    }
    catch {
        Write-Warning "Parse failed for $base. Skipping."
        if (Test-Path $yamlOut) { Remove-Item $yamlOut -Force }
        continue
    }

    # draw using default layouts
    $drawSuccess = $false

    try {
        $drawOut = keymap -c "keymap-drawer/keymap_drawer.config.yaml" `
                          draw `
                          $yamlOut `
                          -o $svgOut 2>&1

        if ($LASTEXITCODE -ne 0) { throw "Draw failed (no JSON)" }

        $drawSuccess = $true
    }
    catch {
        if (Test-Path $svgOut) { Remove-Item $svgOut -Force }
    }

    # draw with physical layouts JSON
    if (-not $drawSuccess) {
        $json = Get-ChildItem -Path "boards/shields" `
                              -Recurse `
                              -Filter "$base.json" `
                              -ErrorAction SilentlyContinue

        if (-not $json) {
            Write-Warning "Draw failed for $base without JSON and JSON file not found. Skipping."
            continue
        }

        try {
            # keymap -c ./keymap-drawer/keymap_drawer.config.yaml `
            #     draw ./keymap-drawer/svg/nuke_pad.yaml `
            #     -j ./boards/shields/nuke_pad/nuke_pad.json `
            #     -o ./keymap-drawer/svg/nuke_pad.svg

            $drawOut = keymap -c "keymap-drawer/keymap_drawer.config.yaml" `
                              draw `
                              $yamlOut `
                              -j $json.FullName `
                              -o $svgOut 2>&1

            if ($LASTEXITCODE -ne 0) { throw "Draw failed (with JSON)" }

            $drawSuccess = $true
        }
        catch {
            Write-Warning "Draw failed for $base (JSON). Skipping."
            if (Test-Path $svgOut) { Remove-Item $svgOut -Force }
            continue
        }
    }
}
