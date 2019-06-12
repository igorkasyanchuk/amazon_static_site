module AmazonStaticSite
  class Upload
    attr_reader :worker

    def initialize(worker)
      @worker = worker
    end

    def list
      result = Dir[worker.folder]
      binding.pry
      result
    end
  end
end