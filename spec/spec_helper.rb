require "rubygems"
require "mongoid"
require "mongoid/compatibility"
require "bundler/setup"
require "rspec"
require File.expand_path("../../lib/mongoid_magic_counter_cache", __FILE__)

Mongoid.configure do |config|
    name = "mongoid_magic_counter_cache_test"
    config.respond_to?(:connect_to) ? config.connect_to(name) : config.master = Mongo::Connection.new.db(name)
end

Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }

RSpec.configure do |c|
    # RSpec 3 with the RSpec 2-era `should` syntax still enabled, so the existing specs run unchanged.
    c.expect_with(:rspec) { |e| e.syntax = [:should, :expect] }
    c.mock_with(:rspec) { |m| m.syntax = [:should, :expect] }
    c.before(:each) do
          Mongoid::Config.respond_to?(:purge!) ? Mongoid::Config.purge! : Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
    end
end
