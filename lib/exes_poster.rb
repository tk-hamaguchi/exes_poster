require 'elasticsearch'

# ExesPoster
#
# @since 0.1.0
# @author tk.hamaguchi@gmail.com
#
module ExesPoster
  @@es_url   = ENV['ELASTICSEARCH_URL']
  @@es_index = 'exes_index'

  autoload :Configurator, 'exes_poster/configurator'
  autoload :Poster,       'exes_poster/poster'

  include Configurator
  include Poster
end
