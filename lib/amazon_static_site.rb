require_relative './amazon_static_site/version'
require 'active_support'
require 'yaml'
require 'rake'
require 'aws-sdk-s3'
require 'json'
require 'cloudflare'
require 'sinatra/base'
require 'zlib'
require 'better_tempfile'
require 'mime/types'

module AmazonStaticSite
  class Error < StandardError; end
end

require_relative './amazon_static_site/utils/string_ext.rb'
require_relative './amazon_static_site/server.rb'
require_relative './amazon_static_site/client/base.rb'
require_relative './amazon_static_site/client/s3.rb'
require_relative './amazon_static_site/client/upload.rb'
require_relative './amazon_static_site/client/cloudflare.rb'
require_relative './amazon_static_site/config.rb'
require_relative './amazon_static_site/service.rb'
require_relative './amazon_static_site/worker.rb'
require_relative './amazon_static_site/local_static_site.rb'
