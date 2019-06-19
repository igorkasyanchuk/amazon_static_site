module AmazonStaticSite
  class Config
    attr_reader :worker, :options, :file

    delegate_missing_to :options

    def initialize(file)
      @file    = file
      @worker  = worker
      @options = JSON.parse(YAML.load_file(file).to_json, object_class: OpenStruct)
    end
  end
end