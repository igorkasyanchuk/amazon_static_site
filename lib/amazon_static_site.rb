require "amazon_static_site/version"
require 'active_support'
require 'yaml'
require 'rake'
require 'aws-sdk-s3'
require 'json'

module AmazonStaticSite
  class Error < StandardError; end
end

require_relative './amazon_static_site/string_ext.rb'
require_relative './amazon_static_site/upload.rb'
require_relative './amazon_static_site/config.rb'
require_relative './amazon_static_site/service.rb'
require_relative './amazon_static_site/worker.rb'