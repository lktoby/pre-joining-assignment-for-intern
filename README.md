# インターン生入社前課題

本課題に取り組み、社員チェックが通れば実務に入ることができます。

# 目的

- 自己解決力を鍛える
- Web / Web アプリケーション開発の基礎を学ぶ

## 技術スタック

### Vue

ユーザーインターフェースの構築のための JavaScript フレームワークで、本課題ではフロントエンドとして使用します。

Vue には二つの書き方 **`Options API`** **`Composition API`** が存在します！
本課題では前者の **`Options API`** という書き方で実装するようにお願いします！

また、ドキュメントを閲覧する際は左上の「API 選択」について `Options` を設定して閲覧してください！

<img width="488" height="386" alt="image" src="https://github.com/user-attachments/assets/3d89677a-6c05-4bfb-a02d-f3a85fd50197" />

**関連技術スタック**

- HTML
- CSS(SCSS/SASS)
- JavaScript(TypeScript)
- Vue Router

**参考資料**

- [はじめに - Vue.js](https://ja.vuejs.org/guide/introduction.html)
- [Vue 3 - 二つの API スタイル](https://ja.vuejs.org/guide/introduction.html#api-stlyes)
- [Vue 3 - ガイド](https://ja.vuejs.org/guide/introduction.html)

---

### Ruby on Rails

プログラミング言語 **Ruby** で実装された、MVC(Model / View / Controller) 設計アーキテクチャの Web フレームワークで、本課題においては Web サーバーサイドとして使用します。

**参考資料**

- [Rails を始めよう - Rails ガイド](https://railsguides.jp/getting_started.htm)
- [MVCモデルについて #プログラミング - Qiita](https://qiita.com/riku-shiru/items/2bed096e106e72e0b58a)

---

### MySQL

MySQL は、オープンソースのリレーショナルデータベース管理システムである。

**参考資料**

- [MySQL :: MySQL 8.0 リファレンスマニュアル](https://dev.mysql.com/doc/refman/8.0/ja/)

---

# Step 0: ⚙️ 環境構築

実装にあたり、環境構築をする必要があります。
以下のステップに沿って開発環境を整備してください。

### 1. リポジトリの fork

1. [本リポジトリ](https://github.com/matcher-inc/pre-joining-assignment-for-intern) にアクセス
2. 右上の Fork をクリック
3. 自身の GitHub アカウントにリポジトリを作成

### 2. リポジトリの clone

<details>
  <summary><h4>SSHを設定済みでない場合</h4></summary>

1. お好きなターミナルアプリを開く
2. `mkdir -p ~/.ssh && cd ~/.ssh` を実行
3. `ssh-keygen -t ed25519 -C "your_email@example.com"` を実行（メールアドレスは適宜変更してください）
4. `> Enter a file in which to save the key ...` と出力されたら `github` と入力
5. コマンド実行が完了するまで Enter を入力
6. 以下をペースト

```sh
cat <<EOS >> ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  UseKeyChain yes
  IdentityFile ~/.ssh/github

EOS
```

</details>

1. Fork したリポジトリにアクセス
2. Code をクリックし、SSH のコマンドをコピー
3. お好きなターミナルアプリを開く
4. `cd ~` でホームディレクトリに移動
5. `git clone` まで入力し、コピーしたコマンドをペースト

### 3. セットアップコマンドの実行

1. `cd ~/pre-joining-assignment-for-intern` を実行
2. `/bin/bash setup.sh` を実行

### 4. コンテナ実行

1. `cd ~/pre-joining-assignment-for-intern` を実行
2. [コマンド一覧](#コマンド一覧)より「コンテナ実行」のコマンドを実行

# Step 1: ✍️ サインアップ機能

[🔗 要件書はこちらから](requirements/step1-sign_up.md)

# Step 2: 🚪 サインイン機能

[🔗 要件書はこちらから](requirements/step2-sign_in.md)

# Step 3: 📖 タスク作成機能

[🔗 要件書はこちらから](requirements/step3-create_task.md)

# Step 4: 📚 タスク一覧機能

[🔗 要件書はこちらから](requirements/step4-show_task_list.md)

# Step 5: ✅ タスク完了化 / 未完了化機能

[🔗 要件書はこちらから](requirements/step5-toggle_task_todo.md)

# Step 6: 🌟 タスクお気に入り機能

[🔗 要件書はこちらから](requirements/step6-add_favorite_task.md)

# Step 7: 👥 フォロー / アンフォロー機能

[🔗 要件書はこちらから](requirements/step7-follow_and_unfollow.md)

---

#### コマンド一覧

```sh
# コンテナ実行
docker compose up

# コンテナ実行（デタッチ）
docker compose up -d --wait
```
