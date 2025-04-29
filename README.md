# Scoopでインストールしたアプリをタスクバーへピン留めする方法

Scoopでインストールしたアプリの場合、タスクバーにピン留めできるのはアプリの現在のバージョンのみで、アプリをアップデートしても古いままとなります。

下記の手順でスクリプトを実行すると、デスクトップのScoopShortcutsフォルダの中に常にアプリの最新版を指すショートカットが作成されます。
このショートカットをタスクバーへドラッグ＆ドロップでピン留めしてください。

# 手順

1. ScoopをインストールしたWindows PCで、ターミナルを開いてください。
2. 次のコマンドをコピーして、貼り付けて、Enterキーで実行してください。
```
Invoke-RestMethod -Uri https://raw.githubusercontent.com/sosuisen/create-scoop-shortcut/refs/heads/main/CreateScoopShortcut.ps1 | Invoke-Expression
```
![image](https://github.com/user-attachments/assets/4122dcb7-0811-44f4-87fd-120f40f9b909)
