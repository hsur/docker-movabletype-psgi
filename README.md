# Movable Type 開発環境
## 動作環境
* Docker 23.0.4+ / Docker Compose 2.17.2+

## 立ち上がる環境
* Apache 2.4(ubuntu:18.04) + PSGI(ubuntu:22.04) + MySQL

## 使い方
### git clone 〜 docker compose build
```bash
git clone https://github.com/hsur/docker-movabletype-psgi.git
cd docker-movabletype-psgi
cp .env.example .env
docker compose build
```

### Movable Type 本体と mt-config.cgi の設置
以下のコマンドを実行することでMTOS-5.2.13とmt-config.cgiを自動的に設置できます。
```bash
bash mtsetup.sh
```

#### Movable Type を下記のように設置
```
docker-movabletype-psgi/
└ src/
    ├ mt/ Movable Type 本体ディレクトリ
    └ html/ webroot
         └ mt-static/ シンボリックリンク or コピー
```

#### mt-config.cgi
```perl
CGIPath        http://localhost:8000/mt/
StaticWebPath  /mt-static/
StaticFilePath /var/www/html/mt-static
BaseSitePath   /var/www/html

ObjectDriver DBI::mysql
Database movabletype
DBUser movabletype
DBPassword movabletype
DBHost db

DefaultLanguage ja

PIDFilePath /var/run/mt.pid
```

### 実行
```bash
docker compose up -d
```

### 管理画面にアクセス
* http://localhost:8000/mt/mt.cgi
    * 「最初のウェブサイトを作成」画面
        * ウェブサイトURL : http://localhost:8000/
        * ウェブサイトパス : /var/www/html

### Tips
#### toolsのスクリプトを実行する
```bash
docker compose exec --user docker mt /var/www/mt/tools/upgrade --name Melody
docker compose exec --user docker mt /var/www/mt/tools/run-periodic-tasks
```

#### MTの再起動
```bash
docker compose restart mt
```

#### .env
```bash
WEB_PORT=8000          # ウェブサーバの外向けのポート（ http://localhost:8000/ ）
APP_PORT=5000          # アプリケーションサーバのポート
DOC_ROOT=/var/www/html # ドキュメントルートのコンテナ内部パス（デフォルトでは ./src が /var/www になっている）
WORK_DIR=/var/www/mt   # MTインストールディレクトリのコンテナ内部パス
```