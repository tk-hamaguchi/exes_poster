module ExesPoster
  # ExesPoster::Configurator
  #
  # @since 0.1.0
  # @author tk.hamaguchi@gmail.com
  #
  module Configurator
    def self.included(klass)
      klass.class_variables.each do |var|
        sym = var.to_s.gsub(/^@@/, '').to_sym
        klass.class_eval <<-EOS
          def self.#{sym}()
            return @@#{sym}
          end

          def self.#{sym}=(obj)
            @@#{sym} = obj
          end
        EOS
      end
      klass.class_eval <<-EOS
        def self.setup
          yield self
        end
      EOS
    end
  end
end
