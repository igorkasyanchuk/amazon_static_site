# http://www.railsjazz.com.s3-website-us-west-1.amazonaws.com/

module AmazonStaticSite
  module Client
    class Upload < Base
      GZIP_FILES = /\.(js|css)$/

      def upload_to(destination)
        result = FileList.new(config.folder + "/**/*.*")
        result -= [config.file] # don not upload config file

        puts "Uploading:"
        result.each do |file|
          pathname  = Pathname.new(file)
          basename  = pathname.basename
          upload_to = pathname.to_s.gsub(config.folder, "").gsub(/^\//, "")

          puts "    #{file}...".green
          upload_file(file: file, upload_to: upload_to, destination: destination)

          if file.downcase =~ GZIP_FILES
            temp_filename = "#{basename}.gz"
            temp          = BetterTempfile.new(temp_filename)
            # gzip file in temp folder
            Zlib::GzipWriter.open(temp.path) do |gz|
              gz.mtime     = File.mtime(file)
              gz.orig_name = temp_filename
              gz.write IO.binread(file)
            end
            # print progress
            print "      GZip: #{temp_filename}".dark_green
            print "...\n".green
            upload_file(file: temp.path, upload_to: upload_to + ".gz", destination: destination)
            upload_file(file: temp.path, upload_to: upload_to + ".gzip", destination: destination)
            # delete temp file
            temp.unlink
          end
        end
        result
      end

      def upload_file(file:, upload_to:, destination:)
        aws_options = {
          acl: "public-read",
          content_type: MIME::Types.type_for(file).first&.content_type
        }
        destination.object(upload_to).upload_file(file, aws_options)
      end

    end
  end
end