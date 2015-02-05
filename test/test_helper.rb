require 'rubygems'
require 'yaml'
require 'active_record'
require 'bundler'
Bundler.require

require 'minitest/autorun'
require 'minitest/autorun'
require 'shoulda/context'

begin
  require 'ruby-debug'
rescue LoadError
  puts "ruby-debug not loaded"
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'app'))

ROOT  = File.join(File.dirname(__FILE__), 'app')
require "config/application"

##
# Boot test app.
# TODO, send orm as param from console
# eg: >rake test data_mapper
#     >rake test mongo_mapper
#
App = Test::App.new(:active_record)

#FIXTURES_DIR  = File.join(File.dirname(__FILE__), "fixtures") 


class Minitest::Test
end

