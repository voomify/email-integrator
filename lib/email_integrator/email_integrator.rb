require 'net/pop'
require 'net/http'
require 'uri'
require 'pp'

# This is the base class that iterates an email and processes inbound requests
# It should be used with craken or cron
#
module EmailIntegrator
  class POP3
    def initialize(connection)
      @connection = connection
      [:server, :username, :password].each do |param|
        raise ArgumentError, "missing argument #{param.to_s}" unless @connection.has_key? param
      end

    end

    [:server, :username, :password].each do |method|
      define_method method do
        @connection[method]
      end
    end

    def is_production?
      ENV["RAILS_ENV"] == "production" ? true : false
    end

    def process(pattern)
      #
      # Connect to email server and look for emails
      #
      errors=[]
      conn = Net::POP3.new(server)
      conn.start(username,
                 password) do |pop|
        pop.mails.each do |msg|
          begin
            xml = msg.pop[pattern]
            if xml
              processed = yield(xml)
              msg.delete if processed && is_production?
            end
          rescue Exception => e
            errors << e
          end
        end
      end
      if errors.size>0
        raise(RuntimeError,
            "Processing email integration generated exception(#{errors.size}).\n"+
            "Until it is resolved it the message will be stuck in the email inbox: (#{server}, #{username})."+
            "Error Messages: " + error_messages(errors))
      end        
    end

    def error_messages(errors)
      message = ""
      errors.each do |e|
        message<< "#{e.class} #{e.message}\n#{clean_backtrace(e)}\n"
      end
      message
    end

    def clean_backtrace(exception)
         if backtrace = exception.backtrace
           if defined?(RAILS_ROOT)
             backtrace.map { |line| line.sub(RAILS_ROOT, '')+"\n" }
           else
             backtrace
           end
         end
       end
  end
end