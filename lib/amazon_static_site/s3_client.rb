module AmazonStaticSite
  class S3Client
    attr_reader :service
    delegate :config, to: :service

    def initialize(service)
      @service  = service
    end

    def create_buckets
      primary
      secondary
    end

    def primary
      @primary ||= get_bucket(config.domain.primary)
    end

    def secondary
      @secondary ||= get_bucket(config.domain.secondary)
    end

    def publish_static_website_on_s3
      puts "Publish static web site:"
      s3_client.put_bucket_website(
        bucket: config.domain.primary,
        website_configuration: {
          index_document: {
            suffix: "index.html"
          },
          error_document: {
            key: "error.html"
          }
        }
      )

      puts "Primary DONE"
      s3_client.put_bucket_website(
        bucket: config.domain.secondary,
        website_configuration: {
          # index_document: {
          #   suffix: "index.html"
          # },
          # error_document: {
          #   key: "error.html"
          # },
          redirect_all_requests_to: {
            host_name: config.domain.primary,
            protocol: "https",
          },
          # routing_rules: [
          #   {
          #     # condition: {
          #     #   http_error_code_returned_equals: "HttpErrorCodeReturnedEquals",
          #     #   key_prefix_equals: "KeyPrefixEquals",
          #     # },
          #     redirect: {
          #       host_name: config.domain.primary,
          #       # http_redirect_code: "301",
          #       # protocol: "https", # accepts http, https
          #       # replace_key_prefix_with: "ReplaceKeyPrefixWith",
          #       # replace_key_with: "ReplaceKeyWith",
          #     },
          #   },
          # ],
        }
      )
      puts "Secondary DONE"
    end

    private

    def get_bucket(name)
      s3_resource.bucket(name).exists? ?
      s3_resource.bucket(name) : s3_client.create_bucket(bucket: name, acl: 'public-read')
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