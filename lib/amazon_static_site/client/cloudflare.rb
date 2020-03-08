module AmazonStaticSite
  module Client
    class Cloudflare < Base
      def configure_dns
        in_cloudflare do |connection|
          account_id = cloudflare_account_id(connection)

          puts "  find or create #{domain_for_cloudflare} in account: #{account_id}"

          zone = fetch_zone(connection)
          unless zone
            connection.zones.create(domain_for_cloudflare, { id: account_id })
            zone = fetch_zone(connection)
          end

          puts "Creating DNS records:".yellow
          puts "  - #{service.s3.s3_primary}"
          puts "  - #{service.s3.s3_secondary}"

          puts "Generating ...".yellow
          zone.dns_records.to_a.each do |record|
            if record.type == 'CNAME' && (record.name == config.domain.secondary || record.name == config.domain.primary)
              record.delete
            end
          end
          www     = zone.dns_records.create('CNAME', 'www', service.s3.s3_primary, proxied: true)
          non_www = zone.dns_records.create('CNAME', '.', service.s3.s3_secondary, proxied: true)

          zone_info = []
          zone_info << [
            zone.value[:name],
            zone.value[:name_servers].join('; '),
            zone.value[:status]
          ]
          puts
          puts "Domain settings (you need to chang nameservers for your domain)".green
          puts Terminal::Table.new(headings: ["Name", "Name Servers", "Status"], rows: zone_info)
          puts
          puts "DNS settings".green
          summary_info = []
          [www, non_www].each do |e|
            summary_info << [ e.type, e.name, ' => ', e.content, e.proxied ]
          end
          puts Terminal::Table.new(headings: ['Type', 'Name', nil, 'Destination', 'Proxied'], rows: summary_info)
          puts "=> Done!".green
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