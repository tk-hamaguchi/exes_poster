# language:ja

機能: 設定

シナリオ: デフォルト値がENV['ELASTICSEARCH_URL']と"exes_index"になっている
  前提 "exes_poster"をrequireする
  ならば `ExesPoster.es_url`は`ENV['ELASTICSEARCH_URL']`と同じになっている
  かつ `ExesPoster.es_index`は"exes_index"となっている

シナリオ: ExesPoster.setupで設定を上書きできる
  前提 "exes_poster"をrequireする
  もし 下記のコードを実行する:
    """
    ExesPoster.setup do |config|
      config.es_url   = 'localhost:8282'
      config.es_index = 'hoge'
    end
    """
  ならば `ExesPoster.es_url`は"localhost:8282"となっている
  かつ `ExesPoster.es_index`は"hoge"となっている

