module AmazonStaticSite
  class Service
    attr_reader :config

    def initialize(config)
      @config  = config
    end

    def bucket
      @bucket ||= begin
        s3_resource.bucket(config.s3.bucket).exists? ?
        s3_resource.bucket(config.s3.bucket) : s3.create_bucket(bucket: config.s3.bucket, acl: 'public-read')
      end
    end

    def publish_static_website_on_s3
      s3_client.put_bucket_website(
        bucket: config.s3.bucket,
        website_configuration: {
          index_document: {
            suffix: "index.html"
          },
          error_document: {
            key: "error.html"
          }
        }
      )
    end

    def dns
      # connection.accounts.first.value[:id]
      # zones = connection.zones
      # zones.create('server.com', {:id=>"c1dbd48dd25976f285034f9a0a31cf01"})
      in_cloudflare do |connection|
        zones = connection.zones
        binding.pry
        puts zones
      end
    end

    private

    def in_cloudflare
      Cloudflare.connect(key: config.cloudflare.api_key, email: config.cloudflare.email) do |connection|
        yield(connection)
      end
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new(aws_credentials)
    end

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new(aws_credentials)
    end

    def aws_credentials
      {
        region: config.s3.region,
        access_key_id: config.s3.access_key_id,
        secret_access_key: config.s3.secret_access_key
      }
    end

  end
end