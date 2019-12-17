module AmazonStaticSite
  class Server
    attr_reader :folder

    def initialize(folder = ARGV[1] || '.')
      require 'rack'
      @folder = folder.gsub(/\/$/, '')
    end

    def start(host: '0.0.0.0', port: 8080)
      handler = Rack::Handler::WEBrick
      app     = LocalStaticSite.new
      app.settings.public_folder = folder
      puts "Starting server on folder: #{app.settings.public_folder} on http:/#{host}:#{port}".green
      handler.run app, Host: host, Port: port
    end

  end
end




