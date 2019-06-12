module AmazonStaticSite
  class Worker
    attr_reader :uploader
    attr_reader :config, :folder

    def initialize(arguments)
      @config = Config.new(arguments[0])
      @folder = arguments[1]

      puts config.options

      uploader = Upload.new(self)
      uploader.list
    end
  end
end