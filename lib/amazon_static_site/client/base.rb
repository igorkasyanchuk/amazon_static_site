module AmazonStaticSite
  module Client
    class Base
      attr_reader :service
      delegate :config, to: :service

      def initialize(service)
        @service  = service
      end

    end
  end
end