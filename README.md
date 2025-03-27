# OBS URL Recorder

Docker コンテナ上で OBS Studio を実行し、指定した URL の画面を録画するためのツールです。

## 概要

OBS Studio を Docker コンテナ内で動作させ、Docker起動時に指定したURLをブラウザで表示して録画できます。  
クラウドサーバ上のように、ヘッドレス環境での録画が可能です。  
OBS Studio への録画操作は OBS の WebSocket インターフェイスを利用することを想定しています。  
VNC を介して OBS の GUI にアクセスし、操作することも可能です。  

## 機能

- Docker コンテナ内での OBS Studio の実行
- 環境変数による URL の指定
- Web コンテンツのキャプチャと録画
- WebSocket経由での録画操作
- VNC を介した OBS Studio の GUI へのアクセス

## 使い方

### セットアップと実行

1. リポジトリをクローン:

```bash
git clone https://github.com/yourusername/obs-url-recorder.git
cd obs-url-recorder
```

2. Docker イメージをビルド:

```bash
docker compose build
```

3. コンテナを起動:

```bash
docker compose up
```

### 環境変数の設定

`docker-compose.yml` ファイルで以下の環境変数をカスタマイズできます:

- `OBS_BROWSER_URL`: 録画する Web ページの URL を指定します。

例:

```yaml
environment:
  - OBS_BROWSER_URL=https://example.com
```

### VNC 接続

コンテナ起動後、VNC クライアントを使用して OBS の GUI にアクセスできます:

```
localhost:5900
```

## ファイル構成

- `Dockerfile`: Docker イメージの構築定義
- `docker-compose.yml`: Docker Compose の設定
- `start.sh`: コンテナ起動時に実行されるスクリプト
- `obs-studio/`: OBS Studio の設定ファイル
- `output`: 動画が出力されるディレクトリ 

## ライセンス

このプロジェクトは [MIT ライセンス](LICENSE) の下で配布されています。

## 謝辞

このプロジェクトは以下のオープンソースソフトウェアを使用しています:

- [OBS Studio](https://obsproject.com/)
- [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml)
- [Fluxbox](http://fluxbox.org/)
- [x11vnc](http://www.karlrunge.com/x11vnc/) Updated on: Fri 28 Mar 2025 04:26:57 AM JST
