#!/bin/bash
set -e

# Rails特有の問題を解決するためのコマンド
rm -f /backend/tmp/pids/server.pid

# production環境の場合のみJSとCSSをビルド
if [ "$RAILS_ENV" = "production" ]; then
  # APIモード以外でアセットコンパイルが必要な場合に利用
  # bundle exec rails assets:clobber
  # bundle exec rails assets:precompile
  # --------------------------------------
  # 本番環境（AWS ECS）への初回デプロイ時に利用
  # 初回デプロイ後にコメントアウトして下さい
  bundle exec rails db:create
  # --------------------------------------
  # 2回目以降のデプロイ時に利用
  # 初回デプロイ後にコメントアウトを外して下さい
  # bundle exec rails db:migrate
fi

# サーバー実行(DockerfileのCMDをセット)
exec "$@"

services:
  backend_app:
    ...
    entrypoint: >
      sh -c "mkdir -p tmp/pids &&
      bundle exec puma -C config/puma.rb"
