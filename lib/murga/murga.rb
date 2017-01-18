require 'set'

require 'active_support/core_ext/object'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'

require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/module/delegation'

require 'rack'

require 'java'
require 'jrjackson'
require 'jruby/core_ext'

require 'pathname'

module Murga

  def self.root
    @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
  end

  def self.vendored_jar_paths
    Dir.glob Murga.root.join('vendor', '**', '*.jar')
  end

end

Murga.vendored_jar_paths.each { |path| require path }

require 'murga/version'
require 'murga/config'
require 'murga/handlers/default'
require 'murga/handlers/base'
require 'murga/handlers/basic'
require 'murga/handlers/rack'
require 'murga/server'
