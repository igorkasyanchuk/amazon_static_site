require 'active_support/all'
require 'yaml'
require 'rake'
require 'nokogiri'
require 'aws-sdk-s3'
require 'json'
require 'cloudflare'
require 'sinatra/base'
require 'zlib'
require 'better_tempfile'
require 'mime/types'
require 'terminal-table'

require_relative './amazon_static_site/version'

module AmazonStaticSite
  class Error < StandardError; end
end

require_relative './amazon_static_site/utils/string_ext.rb'
require_relative './amazon_static_site/server.rb'
require_relative './amazon_static_site/generator.rb'
require_relative './amazon_static_site/client/base.rb'
require_relative './amazon_static_site/client/s3.rb'
require_relative './amazon_static_site/client/upload.rb'
require_relative './amazon_static_site/client/cloudflare.rb'
require_relative './amazon_static_site/config.rb'
require_relative './amazon_static_site/service.rb'
require_relative './amazon_static_site/worker.rb'
require_relative './amazon_static_site/local_static_site.rb'
