module AmazonStaticSite
  class Worker
    attr_reader :config, :service

    def initialize(file:, folder:)
      @config   = Config.new(file: file, folder: folder)
      @service  = Service.new(config)

      puts "Starting...".yellow
      puts "  Config file: #{config.file}"
      puts "  Folder to upload: #{config.folder}"

      puts "Connecting to Amazon:".yellow
      service.run_s3

      puts "Uploading to Amazon:".yellow
      service.run_upload

      puts "Configure Cloudflare:".yellow
      service.run_cloudflare
    end
  end
end