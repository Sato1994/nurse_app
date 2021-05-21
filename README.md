投稿一覧はサインアップせずとも見れるように。
サインアップには name, emailの登録を必須にする。
userサインアップに自には登録率をあげるように、:name, :email, :passwordのみ設定可能とする。:myidは自動付与される

hostサインアップ時には、すべて可能とする。:name,  :email, passwordは必須。 :myidは自動付与される。

api::users::index
  ユーザ一覧ページはホスト側のみ閲覧することができる。条件にあったユーザー検索をすることができる。

api::hosts::index
  ホスト一覧ページはユーザ側のみ閲覧することができる。条件にあったホスト検索をすることができる。


ユーザ、ホスト登録画面
  toggleかなんかでユーザかホストか切り替える。
  true,falseの場合でfunctionを切り替えてホスト、ユーザ登録を区別したい。


signup,signinでaccess-token等をローカルストレージへ記録することでとグインできる。
signoutでdevise_token_authの機能によりaccess-token等が無効になるのでローカルストレージから破棄する。

vuexにsignup,signin後にresponse.data.dataをvuexに保存
ユーザEditではvuexからデータを引き出している。