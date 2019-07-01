module AmazonStaticSite
  class Service
    attr_reader :config

    def initialize(config)
      @config  = config
    end

    def prepare_buckets
      puts "Preparing buckets:"
      primary
      puts "Primary DONE"
      secondary
      puts "Secondary DONE"
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

    def dns
      in_cloudflare do |connection|
        account_id = cloudflare_account_id(connection)

        puts "Creating #{domain_for_cloudflare} in account: #{account_id}"
        connection.zones.create(domain_for_cloudflare, { id: account_id })

        zone = connection.zones.find_by_name(domain_for_cloudflare)

        puts "Creating DNS records"

        if primary_www?
          dns_records = zone.dns_records
          www = zone.dns_records.create('CNAME', 'www', 'www.railsjazz.com.s3-website-us-west-1.amazonaws.com', proxied: true)
          non_www = zone.dns_records.create('CNAME', '.', 'railsjazz.com.s3-website-us-west-1.amazonaws.com', proxied: true)
        else
          www = zone.dns_records.create('CNAME', 'www', 'www.railsjazz.com.s3-website-us-west-1.amazonaws.com', proxied: true)
          non_www = zone.dns_records.create('CNAME', '.', 'railsjazz.com.s3-website-us-west-1.amazonaws.com', proxied: true)
        end
        
        binding.pry
        puts www
        puts '----'
        puts zone
      end
    end

    def primary_www?
      config.domain.primary =~ /^www\./
    end

    def domain_for_cloudflare
      primary_www? ? config.domain.secondary : config.domain.primary
    end

    private

    def get_bucket(name)
      s3_resource.bucket(name).exists? ?
      s3_resource.bucket(name) : s3_client.create_bucket(bucket: name, acl: 'public-read')
    end


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

    def cloudflare_account_id(connection)
      connection.accounts.first.value[:id]
    end

    # {:id=>"3671ee76951a135609a6f333ae23a6ef",
    #   :name=>"railsjazz.com",
    #   :status=>"active",
    #   :paused=>false,
    #   :type=>"full",
    #   :development_mode=>0,
    #   :name_servers=>["ben.ns.cloudflare.com", "jean.ns.cloudflare.com"],
    #   :original_name_servers=>["ns-609.awsdns-12.net", "ns-402.awsdns-50.com", "ns-1066.awsdns-05.org", "ns-2032.awsdns-62.co.uk"],
    #   :original_registrar=>nil,
    #   :original_dnshost=>nil,
    #   :modified_on=>"2019-07-01T18:56:59.679817Z",
    #   :created_on=>"2019-07-01T18:53:15.795189Z",
    #   :activated_on=>"2019-07-01T18:56:47.130043Z",
    #   :meta=>{:step=>4, :wildcard_proxiable=>false, :custom_certificate_quota=>0, :page_rule_quota=>3, :phishing_detected=>false, :multiple_railguns_allowed=>false},
    #   :owner=>{:id=>"06613e4d25fd51a76df8eed6903cbd4e", :type=>"user", :email=>"michael@usadvisors.org"},
    #   :account=>{:id=>"c1dbd    

  end
end