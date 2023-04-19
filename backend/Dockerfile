## ビルドステージ
# 2022年11月時点の最新安定版Rubyの軽量版「alpine」
FROM ruby:3.1.2-alpine AS builder
# 言語設定
ENV LANG=C.UTF-8
# タイムゾーン設定
ENV TZ=Asia/Tokyo
# 2022年11月時点の最新版のbundler
# bundlerのバージョンを固定するための設定
ENV BUNDLER_VERSION=2.3.25
# インストール可能なパッケージ一覧の更新
RUN apk update && \
  apk upgrade && \
  # パッケージのインストール（ビルド時のみ使う）
  apk add --virtual build-packs --no-cache \
  alpine-sdk \
  build-base \
  curl-dev \
  mysql-dev \
  tzdata
# 作業ディレクトリの指定
RUN mkdir /app
WORKDIR /app
# ローカルにあるGemfileとGemfile.lockを
# コンテナ内のディレクトリにコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
# bundlerのバージョンを固定する
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle -v
# bunlde installを実行する
RUN bundle install --jobs=4
# build-packsを削除
RUN apk del build-packs

## マルチステージビルド
# 2022年11月時点の最新安定版Rubyの軽量版「alpine」
FROM ruby:3.1.2-alpine
# 言語設定
ENV LANG=C.UTF-8
# タイムゾーン設定
ENV TZ=Asia/Tokyo
# 本番環境用のRAILS_ENV設定
ENV RAILS_ENV=production
# インストール可能なパッケージ一覧の更新
RUN apk update && \
  apk upgrade && \
  # パッケージのインストール（--no-cacheでキャッシュ削除）
  apk add --no-cache \
  bash \
  mysql-dev \
  tzdata \
  gvim
# 作業ディレクトリの指定
RUN mkdir /backend
WORKDIR /backend
# ビルドステージからファイルをコピー
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . /backend
# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
# 本番環境（AWS ECS）でNginxへのファイル共有用ボリューム
VOLUME /backend/public
VOLUME /backend/tmp
# コンテナ起動時に実行するスクリプト
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3010
