ExesPoster
========

ExesPoster is an exception post tool to Elasticsearch.

Installation
-----

Add this line to your application's Gemfile:

```ruby
gem 'exes_poster'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install exes_poster
```


Getting Started
-----

1. To set an environment variable "ELASTICSEARCH_URL"
  ```bash
  $ export ELASTICSEARCH_URL=localhost:9200
  ```

2. Call `ExesPoster.post_exception` with caught exception in the rescue section.
  ```ruby
  require 'exes_poster'
  
  begin
      raise RuntimeError, 'hoge'
  rescue => e
      ExesPoster.post_exception(e)
  end
  ```

3. You can find exception information at your elasticsearch.
  ```javascript
  {
    "_index"   : "exes_index",
    "_type"    : "exception",
    "_id"      : "eIb4VGPbRB6tw0eGnUXUXA",
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
  ```

in Japanese
-----
 * [使い方](features/post_exception_to_elasticsearch.feature)


Configuration
-----

You can set Elasticsearch url and index name.

```ruby
ExesPoster.setup do |config|
  config.es_url   = 'example.com:9200'
  config.es_index = 'hoge_test'
end
```

Test
-----

1. You set an environment variable DOCKER_HOST or ELASTICSEARCH_URL
  ```bash
  $ export ELASTICSEARCH_URL=localhost:9200
  ```
  or
  ```bash
  $ eval $(docker-machine env default)
  ```
 
2. Then exec rake
  ```bash
  $ bundle exec rake
  ```
