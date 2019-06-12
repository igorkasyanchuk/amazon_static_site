module AmazonStaticSite
  class Config
    attr_reader :worker, :options

    def initialize(file)
      @worker  = worker
      binding.pry
      @options = OpenStruct.new(YAML.load_file(file))
    end
  end
end