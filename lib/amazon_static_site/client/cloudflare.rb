module AmazonStaticSite
  module Client
    class Cloudflare < Base
      def configure_dns
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

          puts '----'
          puts www
          puts non_www
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

      def in_cloudflare
        Cloudflare.connect(key: config.cloudflare.api_key, email: config.cloudflare.email) do |connection|
          yield(connection)
        end
      end

      def cloudflare_account_id(connection)
        connection.accounts.first.value[:id]
      end

    end
  end
end