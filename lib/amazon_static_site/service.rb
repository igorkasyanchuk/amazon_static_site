module AmazonStaticSite
  class Service
    attr_reader :config, :s3, :cloudflare, :uploader

    def initialize(config)
      @config     = config
      @s3         = S3Client.new(self)
      @cloudflare = CloudflareClient.new(self)
      @upload     = UploadClient.new(self)
    end

    def run_s3
      s3.create_buckets
      s3.publish_static_website_on_s3
    end

    def run_cloudflare
      cloudflare.configure_dns
    end

    def run_upload
      #uploader.upload
    end

  end
end