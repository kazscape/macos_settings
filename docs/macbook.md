# MacBook Pro 専用セットアップ

このドキュメントでは、MacBook Proでのみ必要な手動インストール手順を記録します。

## Karabiner-Elements

Karabiner-Elementsは、キーボードカスタマイズツールです。MacBook Proの内蔵キーボードを使用する際に有用です。

**重要**: このセットアップではKarabiner-ElementsのDriverKit（仮想キーボードドライバー）をKanataが利用します。

### インストール方法

Ansibleで自動インストールされます。手動でインストールする場合：

```bash
brew install --cask karabiner-elements
```

**インストール完了: 2026-01-05**

### 初回セットアップ

1. アプリケーションを起動
2. システム設定で必要な権限を許可
   - **プライバシーとセキュリティ** > **入力監視**
   - **プライバシーとセキュリティ** > **アクセシビリティ**
3. システム拡張（DriverKit）を承認
   - 初回起動時にシステム拡張のインストールが要求されます
   - **許可**をクリックして承認してください
4. Macを再起動（システム拡張有効化のため）

**セットアップ完了: 2026-01-05**

### Kanataと併用する場合の設定

Kanataをメインのキーボードカスタマイズツールとして使用する場合：

1. Karabiner-ElementsのDriverKitはそのまま有効にしておく（Kanataが利用します）
2. Karabiner-Elementsのアプリは手動で必要時のみ起動
3. 自動起動の設定:
   - **システム設定** > **プライバシーとセキュリティ** > **ログイン項目と機能拡張**
   - 「バックグラウンドでの実行を許可」セクション:
     - `karabiner_console_user_server`（Karabiner CoreSystem）: **有効**（必須）
     - `karabiner_grabber`（Karabiner-Elements）: **無効**（Kanata使用時は不要）
     - `karabiner_observer`（Karabiner-EventViewer）: **無効**（不要）

### キーマッピング設定

Karabiner-Elements単独で使用する場合のみ：

1. Karabiner-Elementsを手動で起動
2. Simple Modificationsタブで設定
3. 必要なキーマッピングを設定

**注意**: KanataとKarabiner-Elementsの両方でキーマッピングを設定すると競合します。どちらか一方をメインとして使用してください。

### 設定ファイル

設定ファイルは以下のディレクトリに保存されます：

```
~/.config/karabiner/
```

## Kanata

Kanataは、高度なキーボードカスタマイズツールです。Lispライクな設定言語を使用して、複雑なキーマッピングやレイヤー機能を実現できます。

### 前提条件

**重要**: KanataはKarabiner-ElementsのDriverKit（仮想キーボードドライバー）を利用します。
- Karabiner-Elementsを先にインストールする必要があります
- Karabiner-ElementsのDriverKitシステム拡張が有効になっていること
- Karabiner-Elementsのアプリやgrabber daemonは**起動不要**です

### インストール方法

Ansibleで自動インストールされます。手動でインストールする場合：

```bash
brew install kanata
```

**インストール完了: 2026-01-05**

### 設定ファイル

Ansibleにより以下のファイルが自動配置されます：

- 設定ファイル: `~/.config/kanata/kanata.kbd`
- ヘルパースクリプト: `~/.local/bin/kanata-start`, `~/.local/bin/kanata-stop`

基本設定（CapsLock → Ctrl、内蔵キーボードのみ適用）:

```lisp
;; Kanata Configuration
;; Basic key remapping for MacBook Pro

;; Configuration section
;; Only apply to MacBook Pro built-in keyboard, exclude external keyboards
(defcfg
  process-unmapped-keys false
  
  ;; macOS device name filtering
  ;; Include only Apple Internal Keyboard (MacBook Pro built-in keyboard)
  ;; This prevents Kanata from intercepting external keyboards like Corne with VIA/Vial
  macos-dev-names-include (
    "Apple Internal Keyboard / Trackpad"
  )
)

(defsrc
  caps
)

(deflayer base
  lctl
)
```

**重要**: `macos-dev-names-include`設定により、Kanataは内蔵キーボードにのみ適用されます。外部キーボード（Corne等）には影響しないため、VIA/Vialなどの独自設定と共存できます。

### 権限設定（必須）

Kanataを使用するには、システム設定で以下の権限を付与する必要があります：

#### 1. 入力監視 (Input Monitoring)
キーボード入力を読み取るために必要です。

1. **システム設定** > **プライバシーとセキュリティ** > **入力監視**
2. **+** ボタンをクリック
3. `/opt/homebrew/bin/kanata` を追加
4. チェックボックスを有効化

#### 2. アクセシビリティ (Accessibility)
変換したキー入力を送信するために必要です。

1. **システム設定** > **プライバシーとセキュリティ** > **アクセシビリティ**
2. **+** ボタンをクリック
3. `/opt/homebrew/bin/kanata` を追加
4. チェックボックスを有効化

**権限設定完了: 2026-01-05**

### 動作確認

権限を設定したら、手動でテストします：

```bash
# Kanataを起動（フォアグラウンドで実行）
kanata-start

# CapsLockキーを押してCtrlとして動作することを確認
# 問題なければ Ctrl+C で停止

# または別ターミナルから停止
kanata-stop
```

**動作確認完了: 2026-01-05**

### 自動起動の設定（オプション）

手動テストで正常に動作することを確認した後、必要に応じて自動起動を設定できます。

#### LaunchDaemonの作成

```bash
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

#### 動作確認

```bash
# Kanataが実行中か確認
ps aux | grep kanata | grep -v grep

# ログを確認
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

### Karabiner-Elementsとの併用

Kanataは Karabiner-ElementsのDriverKitを利用するため、以下の構成で併用できます：

- ✅ **Karabiner-Elements**: インストール済み（DriverKit提供）
- ✅ **Karabiner-ElementsのDriverKit**: 有効（システム拡張）
- ⚠️ **Karabiner-Elementsのアプリ**: 起動不要（必要時のみ手動起動）
- ✅ **Kanata**: メインのキーボードカスタマイズツールとして使用

**注意**: Karabiner-ElementsとKanataを同時に使う場合、両方でキーマッピングを設定すると競合する可能性があります。どちらか一方をメインとして使用してください。
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
