# http://www.railsjazz.com.s3-website-us-west-1.amazonaws.com/

module AmazonStaticSite
  module Client
    class Upload < Base

      def upload(destination)
        result = FileList.new(config.folder + "/**/*.*")
        result -= [config.file]
        puts "Uploading:"
        result.each do |file|
          puts "  *#{file}".yellow
          upload_file(file: file, destination: destination)
        end
        result
      end

      def upload_file(file:, destination:)
        name        = Pathname.new(file)
        aws_options = { acl: "public-read" }
        file_name   = name.basename
        upload_to   = name.to_s.gsub(config.folder, "").gsub(/^\//, "")

        puts "uploading to: #{upload_to}"
        destination.object(upload_to).upload_file(file, aws_options)
      end

    end
  end
end