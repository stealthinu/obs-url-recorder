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

### dockerの設定

`docker-compose.yml` ファイルで以下の変数でカスタマイズできます:

#### OBS_BROWSER_URL

録画する Web ページの URL を指定します。

例:

```yaml
environment:
  - OBS_BROWSER_URL=https://example.com
```

#### SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_FPS, ReC_FORMAT

録画・表示する仮想画面の解像度やフレームレートを環境変数で指定できます。

- `SCREEN_WIDTH` : 画面の横幅（ピクセル）デフォルト `1280`
- `SCREEN_HEIGHT`: 画面の縦幅（ピクセル）デフォルト `720`
- `SCREEN_FPS`   : フレームレート（fps）デフォルト `30`
- `REC_FORMAT`   : 録画ファイルのフォーマット デフォルト `mp4`



例:

```yaml
environment:
  - SCREEN_WIDTH=1920
  - SCREEN_HEIGHT=1080
  - SCREEN_FPS=60
  - REC_FORMAT=mkv
```

#### shm_size

録画する対象に動画が含まれている場合など、shm_sizeを大きく設定しておく必要があります。

例:

```yaml
shm_size: 2gb
```

#### docker-compose 設定例

```yaml
  obs:
    image: ghcr.io/stealthinu/obs-url-recorder:master
    environment:
      OBS_BROWSER_URL: http://aituber:3000/?slide=demo&autoplay=true
      SCREEN_WIDTH: 1024
      SCREEN_HEIGHT: 720
      SCREEN_FPS: 20
      REC_FORMAT: mp4
    shm_size: 2gb
    ports:
      - "5900:5900"  # VNC port
      - "4455:4455"  # OBS websocket port
    volumes:
      - ./data:/data
      - ./output:/home/obsuser/output
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
