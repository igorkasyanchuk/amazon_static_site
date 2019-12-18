module AmazonStaticSite
  class Generator
    attr_reader :folder

    def initialize(folder = ARGV[1] || '.')
      require 'fileutils'
      @folder = folder.gsub(/\/$/, '')
    end

    def start
      print "Creating folder #{folder} ...".green
      FileUtils.mkdir_p(folder)
      print "OK\n".yellow

      print "Copying #{template} to #{destination} ...".green
      FileUtils.copy_entry template, destination
      print "OK\n".yellow

      print "Generating config #{destination}/config/site.yml ...".green
      generate_config
      print "OK\n".yellow
    end

    private

    def template
      File.dirname(File.expand_path('..', __dir__)) + "/template"
    end

    def destination
      Dir.pwd + "/" + folder
    end

    def generate_config
      FileUtils.mv "#{destination}/config.yml.sample", "#{destination}/config.yml"
    end

  end
end




