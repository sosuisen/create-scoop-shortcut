# タスクバーへ登録可能なアプリのショートカットを作るスクリプト

# Scoopでインストールしたアプリの場合、
# タスクバーにピン留めできるのはアプリの現在のバージョンのみで、
# アプリをアップデートしても古いままとなります。
# このスクリプトを実行すると、デスクトップのScoopShortcutsフォルダの中に
# 常にアプリの最新版を指すショートカットを作成します。
# このショートカットをタスクバーへドラッグ＆ドロップで登録してください。

# Scoopのappsディレクトリの場所
$appsDir = "$env:USERPROFILE\scoop\apps"

# 保存先フォルダは、デスクトップのScoopShortcutsフォルダ
$desktop = [Environment]::GetFolderPath("Desktop")
$outputDir = Join-Path $desktop "ScoopShortcuts"

# 保存先フォルダがなければ作成
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# アプリごとにループして.lnkを作成
Get-ChildItem $appsDir -Directory | ForEach-Object {
    $appName = $_.Name
    $currentPath = Join-Path $_.FullName "current"

    # .exe を探す（currentフォルダ直下のみ）
    $exePath = Get-ChildItem $currentPath -Filter *.exe -File -Recurse |
               Sort-Object LastWriteTime -Descending |
               Select-Object -First 1

    if ($exePath) {
        $lnkPath = Join-Path $outputDir "$appName.lnk"
        $wshShell = New-Object -ComObject WScript.Shell
        $shortcut = $wshShell.CreateShortcut($lnkPath)
        $shortcut.TargetPath = $exePath.FullName
        $shortcut.WorkingDirectory = $exePath.DirectoryName
        $shortcut.IconLocation = $exePath.FullName
        $shortcut.Save()
        Write-Host "Created shortcut for $appName"
    } else {
        Write-Host "No .exe found for $appName"
    }
}
