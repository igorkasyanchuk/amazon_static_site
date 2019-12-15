module AmazonStaticSite
  class UploadClient
    attr_reader :worker

    def initialize(worker)
      @worker = worker
    end

    def upload
      result = FileList.new(worker.folder + "/**/*.*")
      result -= [worker.config.file]
      puts "Uploading:"
      result.each do |file|
        puts "  *#{file}".yellow
        upload_file(file)
      end
      result
    end

    # http://www.railsjazz.com.s3-website-us-west-1.amazonaws.com/

    def upload_file(file)
      name        = Pathname.new(file)
      aws_options = { acl: "public-read" }
      file_name   = name.basename
  
      upload_to = name.to_s.gsub(worker.folder, "").gsub(/^\//, "")

      puts "uploading to: #{upload_to}"
  
      worker.service.primary.object(upload_to).upload_file(file, aws_options)
    end
  end
end