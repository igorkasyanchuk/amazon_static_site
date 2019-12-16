module AmazonStaticSite
  module Client
    class Cloudflare < Base
      def configure_dns
        in_cloudflare do |connection|
          account_id = cloudflare_account_id(connection)

          puts "Find or create #{domain_for_cloudflare} in account: #{account_id}"

          zone = fetch_zone(connection)
          unless zone
            connection.zones.create(domain_for_cloudflare, { id: account_id })
            zone = fetch_zone(connection)
          end

          puts "Creating DNS records:".yellow
          puts "- #{service.s3.s3_primary}"
          puts "- #{service.s3.s3_secondary}"

          if primary_www?
            www     = zone.dns_records.create('CNAME', 'www', service.s3.s3_primary, proxied: true)
            non_www = zone.dns_records.create('CNAME', '.', service.s3.s3_secondary, proxied: true)
          else
            www     = zone.dns_records.create('CNAME', 'www', service.s3.s3_primary, proxied: true)
            non_www = zone.dns_records.create('CNAME', '.', service.s3.s3_secondary, proxied: true)
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

      def fetch_zone(connection)
        connection.zones.find_by_name(domain_for_cloudflare)
      end

      def in_cloudflare
        # use Cloadflare API client
        ::Cloudflare.connect(key: config.cloudflare.api_key, email: config.cloudflare.email) do |connection|
          yield(connection)
        end
      end

      def cloudflare_account_id(connection)
        connection.accounts.first.value[:id]
      end

    end
  end
end