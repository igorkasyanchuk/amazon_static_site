module AmazonStaticSite
  module Client
    class S3 < Base
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
        puts "Publish static web site:".yellow
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
        puts "  Primary #{config.domain.primary} DONE"
        s3_client.put_bucket_website(
          bucket: config.domain.secondary,
          website_configuration: {
            redirect_all_requests_to: {
              host_name: config.domain.primary,
              protocol: "https",
            },
          }
        )
        puts "  Secondary #{config.domain.secondary} DONE"
      end

      def s3_primary; s3_domain(config.domain.primary); end
      def s3_secondary; s3_domain(config.domain.secondary); end

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

      def s3_domain(domain)
        [
          domain,
          ".s3-website-#{config.s3.region}.amazonaws.com"
        ].join
      end

    end
  end
end