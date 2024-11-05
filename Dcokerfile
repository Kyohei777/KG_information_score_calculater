# ベースイメージとしてRubyを指定
FROM ruby:3.1

# 作業ディレクトリを作成
WORKDIR /usr/src/app

# GemfileとGemfile.lockをコピーして、依存関係をインストール
COPY Gemfile* ./
RUN bundle install

# プログラムのソースコードをコピー
COPY . .

# コンテナ起動時にRubyプログラムを実行するコマンドを指定（ここではデフォルトコマンドを設定しません）
CMD ["irb"]
