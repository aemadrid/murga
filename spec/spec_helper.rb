$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['RACK_ENV'] ||= 'test'

require 'rubygems'
require 'bundler/setup'
require 'jbundler'

Bundler.setup(:default, ENV['RACK_ENV'])

require 'murga'
require 'http'

EXAMPLE1_ROOT = Murga.root.join('spec', 'example_1')
EXAMPLE2_ROOT = Murga.root.join('spec', 'example_2')
EXAMPLE3_ROOT = Murga.root.join('spec', 'example_3')

require_relative 'support/server'
require_relative 'support/requests'
require_relative 'support/handlers'