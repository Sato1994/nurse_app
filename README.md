投稿一覧はサインアップせずとも見れるように。
サインアップには name, emailの登録を必須にする。
userサインアップに自には登録率をあげるように、:name, :email, :address, :wanted, :sex, :age, :yearのみ設定可能とする。

hostサインアップ時には、すべて可能とする。

api::users::index
  ユーザ一覧ページはホスト側のみ閲覧することができる。条件にあったユーザー検索をすることができる。

api::hosts::index
  ホスト一覧ページはユーザ側のみ閲覧することができる。条件にあったホスト検索をすることができる。