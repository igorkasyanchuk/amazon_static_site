module AmazonStaticSite
  class Config
    attr_reader :worker, :options, :file, :folder

    delegate_missing_to :options

    def initialize(file:, folder:)
      @file    = file
      @folder  = folder
      @worker  = worker
      @options = JSON.parse(YAML.load_file(file).to_json, object_class: OpenStruct)
    end
  end
end