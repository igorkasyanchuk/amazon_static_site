module AmazonStaticSite
  class Worker
    attr_reader :config, :service

    def initialize(arguments)
      @config   = Config.new(file: arguments[0], folder: arguments[1])
      @service  = Service.new(config)

      puts "Starting".yellow
      puts "Config file: #{config.file}"
      puts "Folder to upload: #{config.folder}"

      puts "Connecting to Amazon:"
      service.run_s3

      puts "Uploading to Amazon:"
      service.run_upload

      puts "Configure Cloudflare:"
      service.run_cloudflare
    end
  end
end