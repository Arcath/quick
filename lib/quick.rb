# Libraries
require 'yaml'

# Base Module
module Quick
  BasePath = File.expand_path("../../", __FILE__)
end

# Internal Requires
require "#{Quick::BasePath}/lib/quick/config"
require "#{Quick::BasePath}/lib/quick/log"
require "#{Quick::BasePath}/lib/quick/ssh"