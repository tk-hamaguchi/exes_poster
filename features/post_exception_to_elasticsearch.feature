# language:ja

機能: 例外ログのPOST

背景:
  * タイムスタンプを"2016-09-21T16:28:09.753+09:00"とする
  * 環境変数に"ELASTICSEARCH_URL"が設定されている
  * "exes_poster"をrequireする
  * 下記のコードを実行する:
    """
    ExesPoster.setup do |config|
      config.es_url   = ENV['ELASTICSEARCH_URL']
      config.es_index = 'exes_index_test'
    end
    """
  * `ExesPoster.es_url`は`ENV['ELASTICSEARCH_URL']`と同じになっている
  * `ExesPoster.es_index`は"exes_index_test"となっている
  * Elasticsearchに空のテスト用indexが存在している

シナリオ: post_exceptionでElasticsearchにRuntimeErrorをPOSTし、内容が正しいことを確認する
  もし 下記のコードを実行する:
    """
    re = RuntimeError.new('hoge')
    re.set_backtrace([
      "/PATH/TO/ERROR/FILE1.rb:123:in `block (3 levels) in <top (required)>'",
      "/PATH/TO/ERROR/FILE2.rb:456:in `block (2 levels) in function'",
      "/PATH/TO/ERROR/FILE3.rb:15:in `<main>'"
    ])

    ExesPoster.post_exception(re)
    """
  ならば ElasticSearchに下記のドキュメントが登録されている:
    """
    {
      "_index"   : "exes_index_test",
      "_type"    : "exception",
      "_id"      : ___LAST_POSTED_ID___,
      "_version" : 1,
      "found"    : true,
      "_source"  : {
        "message"    : "hoge",
        "@timestamp" : "2016-09-21T16:28:09.753+09:00",
        "detail"     : {
          "class"     : "RuntimeError",
          "backtrace" : [
            "/PATH/TO/ERROR/FILE1.rb:123:in `block (3 levels) in <top (required)>'",
            "/PATH/TO/ERROR/FILE2.rb:456:in `block (2 levels) in function'",
            "/PATH/TO/ERROR/FILE3.rb:15:in `<main>'"
          ]
        }
      }
    }
    """
