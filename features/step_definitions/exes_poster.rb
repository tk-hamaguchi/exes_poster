Given(/^タイムスタンプを"([^"]*)"とする$/) do |timestamp|
  Timecop.freeze(Time.parse(timestamp))
end

Given(/^"([^"]*)"をrequireする$/) do |gem_name|
  require gem_name
end

Given(/^環境変数に"([^"]*)"が設定されている$/) do |key|
  expect(key).to_not be_nil
  expect(key.length).to_not eq 0
  Cucumber.logger.debug "ENV['#{key}'] => #{ENV[key]}\n"
end

Given(/^Elasticsearchに空のテスト用indexが存在している$/) do
  c = Elasticsearch::Client.new(url: ExesPoster.es_url)
  if c.indices.exists?(index: ExesPoster.es_index)
    c.indices.delete(index: ExesPoster.es_index)
  end
  c.indices.create(index: ExesPoster.es_index)
end

When(/^下記のコードを実行する:$/) do |code|
  @result = eval(code)
end

Then(/^`([^"]*)`は"([^"]*)"となっている$/) do |code, value|
  expect(eval(code)).to eq value
end

Then(/^`([^"]*)`は`([^"]*)`と同じになっている$/) do |code, value|
  expect(eval(code)).to eq eval(value)
end

Then(/^ElasticSearchに下記のドキュメントが登録されている:$/) do |doc|
  c = Elasticsearch::Client.new(url: ExesPoster.es_url)
  d = c.get index: ExesPoster.es_index, type: :exception, id: @result

  doc.gsub!(/___LAST_POSTED_ID___/, '"' + @result + '"')
  j = JSON.parse(doc)
  expect(d).to match(j)
end

