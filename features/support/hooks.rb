require 'uri'
require 'cgi'
require 'docker'

$container_id = nil

AfterConfiguration do |config|
  if ENV['ELASTICSEARCH_URL'].nil? || ENV['ELASTICSEARCH_URL'].length == 0
    if ENV['DOCKER_HOST'].nil? || ENV['DOCKER_HOST'].length == 0
      raise 'Please set DOCKER_HOST or ELASTICSEARCH_URL'
    end

    Cucumber.logger.debug "Elasticsearch with Docker:\n"
    container = Docker::Container.create(
      'Image'      => 'elasticsearch:5',
      'Env'        => ['ES_JAVA_OPTS=-Xms512m -Xmx512m'],
      'Cmd'        => %w(-E bootstrap.ignore_system_bootstrap_checks=true),
      'HostConfig' => { 'PublishAllPorts' => true }
    )
    $container_id = container.id
    u = URI.parse(container.connection.url)
    Cucumber.logger.debug "  * Create Container[#{$container_id}] at #{u}.\n"

    container.start
    Cucumber.logger.debug "  * Container[#{$container_id}] starting...\n"

    100.times.each do
      break if container.streaming_logs(stdout: true) =~ /started$/
      sleep 1
    end
    Cucumber.logger.debug "  * Container[#{$container_id}] was started.\n"

    c2 = Docker::Container.get $container_id
    port = c2.info['NetworkSettings']['Ports']['9200/tcp'][0]['HostPort']
    Cucumber.logger.debug "  * Binding port 9200/tcp to #{port}.\n"

    ENV['ELASTICSEARCH_URL'] = "#{u.host}:#{port}"
    Cucumber.logger.debug "  * Set ELASTICSEARCH_URL to #{ENV['ELASTICSEARCH_URL']}.\n\n"
  end
end

at_exit do
  unless $container_id.nil?
    Cucumber.logger.debug "\nElasticsearch with Docker:\n"
    ENV['ELASTICSEARCH_URL'] = nil
    c2 = Docker::Container.get $container_id
    Cucumber.logger.debug "  * Container[#{$container_id}] stopping...\n"
    c2.stop
    Cucumber.logger.debug "  * Container[#{$container_id}] was stopped.\n"
    c2.delete
    Cucumber.logger.debug "  * Container[#{$container_id}] was deleted.\n"
  end
end

Around do |scenario, block|
  es_u = ENV['ELASTICSEARCH_URL']
  block.call
  ENV['ELASTICSEARCH_URL'] = es_u
  Timecop.return
end
