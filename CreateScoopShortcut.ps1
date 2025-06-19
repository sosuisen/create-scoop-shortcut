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

    # .exe を探す（トップディレクトリ優先）
    $topExeFiles = Get-ChildItem $currentPath -Filter *.exe -File |
                   Sort-Object LastWriteTime -Descending
    
    if ($topExeFiles) {
        # アプリ用のディレクトリを作成
        $appOutputDir = Join-Path $outputDir $appName
        if (-not (Test-Path $appOutputDir)) {
            New-Item -ItemType Directory -Path $appOutputDir | Out-Null
        }
        
        # トップディレクトリに.exeが見つかった場合、それらのみを処理
        foreach ($exeFile in $topExeFiles) {
            $exeName = [System.IO.Path]::GetFileNameWithoutExtension($exeFile.Name)
            $lnkPath = Join-Path $appOutputDir "$exeName.lnk"
            $wshShell = New-Object -ComObject WScript.Shell
            $shortcut = $wshShell.CreateShortcut($lnkPath)
            $shortcut.TargetPath = $exeFile.FullName
            $shortcut.WorkingDirectory = $exeFile.DirectoryName
            $shortcut.IconLocation = $exeFile.FullName
            $shortcut.Save()
            Write-Host "Created shortcut for $appName/$exeName"
        }
    } else {
        # トップディレクトリに.exeがない場合のみ、サブディレクトリを探す
        $exeFiles = Get-ChildItem $currentPath -Filter *.exe -File -Recurse |
                    Sort-Object LastWriteTime -Descending
        
        if ($exeFiles) {
            # アプリ用のディレクトリを作成
            $appOutputDir = Join-Path $outputDir $appName
            if (-not (Test-Path $appOutputDir)) {
                New-Item -ItemType Directory -Path $appOutputDir | Out-Null
            }
            
            foreach ($exeFile in $exeFiles) {
                $exeName = [System.IO.Path]::GetFileNameWithoutExtension($exeFile.Name)
                $lnkPath = Join-Path $appOutputDir "$exeName.lnk"
                $wshShell = New-Object -ComObject WScript.Shell
                $shortcut = $wshShell.CreateShortcut($lnkPath)
                $shortcut.TargetPath = $exeFile.FullName
                $shortcut.WorkingDirectory = $exeFile.DirectoryName
                $shortcut.IconLocation = $exeFile.FullName
                $shortcut.Save()
                Write-Host "Created shortcut for $appName/$exeName"
            }
        } else {
            Write-Host "No .exe found for $appName"
        }
    }
}
