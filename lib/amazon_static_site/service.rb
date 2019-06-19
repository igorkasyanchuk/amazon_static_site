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

    private

    def s3_client
      @s3_client ||= Aws::S3::Client.new(aws_credentials)
    end

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new(aws_credentials)
    end

    def cloudfront_client
      @cloudfront_client ||= Aws::CloudFront::Client.new(aws_credentials)
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