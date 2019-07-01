module AmazonStaticSite
  class Worker
    attr_reader :uploader
    attr_reader :config, :folder, :service, :uploader

    def initialize(arguments)
      @config   = Config.new(arguments[0])
      @folder   = arguments[1]
      @service  = Service.new(@config)
      @uploader = Upload.new(self)

      puts "Connecting to Amazon:"
      service.prepare_buckets

      puts "Config file: #{arguments[0]}"
      puts "Folder to upload: #{arguments[1]}"

      #uploader.upload

      service.publish_static_website_on_s3

      service.dns
    end
  end
end