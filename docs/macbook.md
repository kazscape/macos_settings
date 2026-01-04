# MacBook Pro 専用セットアップ

このドキュメントでは、MacBook Proでのみ必要な手動インストール手順を記録します。

## Karabiner-Elements

Karabiner-Elementsは、キーボードカスタマイズツールです。MacBook Proの内蔵キーボードを使用する際に有用です。

### インストール方法

```bash
brew install --cask karabiner-elements
```

**インストール完了: 2026-01-05**

### 初回セットアップ

1. アプリケーションを起動
2. システム設定で必要な権限を許可
   - プライバシーとセキュリティ > 入力監視
   - プライバシーとセキュリティ > アクセシビリティ
3. 自動起動の設定
   - システム設定 > プライバシーとセキュリティ > ログイン項目と機能拡張
   - 「バックグラウンドでの実行を許可」セクションで：
     - `karabiner_grabber`（Karabiner-Elements）のチェックを外す
     - `karabiner_observer`（Karabiner-EventViewer）のチェックを外す
     - `karabiner_console_user_server`（Karabiner CoreSystem）はチェックを入れたまま
4. メニューバーからKarabiner-Elementsを終了
5. Macを再起動
6. 再起動後、Karabiner-Elementsが自動起動していないことを確認

**セットアップ完了: 2026-01-05**

### キーマッピング設定

必要なキーマッピングは以下の手順で設定します：

1. Karabiner-Elementsを手動で起動（必要な時のみ）
2. Simple Modificationsタブで設定
3. 必要なキーマッピングを設定

### 設定ファイル

設定ファイルは以下のディレクトリに保存されます：

```
~/.config/karabiner/
```

## Kanata

Kanataは、高度なキーボードカスタマイズツールです。Lispライクな設定言語を使用して、複雑なキーマッピングやレイヤー機能を実現できます。

### インストール方法

```bash
brew install kanata
```

**インストール完了: 2026-01-05**

### 初期設定

Kanataがroot権限で`~/.config/kanata`を作成してしまう問題があるため、以下のコマンドでユーザー権限のディレクトリに変更します：

```bash
sudo pkill -f kanata; sudo rm -rf ~/.config/kanata; mkdir ~/.config/kanata
```

このコマンドは以下を実行します：
1. kanataプロセスを停止
2. root権限のディレクトリを削除
3. ユーザー権限でディレクトリを再作成（フォルダの復活を防ぐため素早く実行）

### 設定ファイル

設定ファイルは以下のディレクトリに保存されます：

```
~/.config/kanata/
```

### 基本的な設定例

`~/.config/kanata/kanata.kbd`を作成し、以下の内容を記述します：

```lisp
(defsrc
  caps
)

(deflayer base
  lctl
)
```

この設定は、CapsLockキーをCtrlキーに変更します。

### 動作確認

設定が正しく動作するか確認します：

```bash
# Kanataを起動（sudo権限が必要）
sudo kanata --cfg ~/.config/kanata/kanata.kbd

# CapsLockキーがCtrlとして動作することを確認

# 確認後、終了
sudo pkill kanata
```

### 自動起動の設定

#### 1. LaunchDaemonの作成

Ansible実行後に表示される手順に従って、LaunchDaemonを作成します：

```bash
# Ansibleで自動生成された手順を使用
# または手動で以下のコマンドを実行：

sudo tee /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kazuharu.yamauchi.kanata</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/kanata</string>
        <string>--cfg</string>
        <string>/Users/kazuharu.yamauchi/.config/kanata/kanata.kbd</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/kanata.out.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/kanata.err.log</string>
</dict>
</plist>
EOF

# LaunchDaemonを読み込んで起動
sudo launchctl load -w /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist
```

**セットアップ完了: 2026-01-05**

#### 2. 入力監視権限の付与（必須）

Kanataがキーボードを制御するには、システム設定で入力監視権限を付与する必要があります：

1. **システム設定を開く**
2. **プライバシーとセキュリティ** > **入力監視** を選択
3. **kanata** または関連プロセスを許可リストに追加
4. 変更を反映させるため、Kanataを再起動：
   ```bash
   sudo launchctl unload /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist
   sudo launchctl load -w /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist
   ```

#### 3. 動作確認

```bash
# Kanataが実行中か確認
ps aux | grep kanata | grep -v grep

# ログを確認（エラーがないことを確認）
tail -f /tmp/kanata.err.log

# CapsLockキーを押してCtrlとして動作することを確認
```

**自動起動の停止・削除:**

```bash
# サービスを停止してアンロード
sudo launchctl unload /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist

# plistファイルを削除（必要に応じて）
sudo rm /Library/LaunchDaemons/com.kazuharu.yamauchi.kanata.plist
```

## その他のMacBook Pro専用ツール

今後、MacBook Pro固有のツールを追加する場合は、このセクションに記録してください。
