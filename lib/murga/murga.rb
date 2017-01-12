require 'set'

require 'active_support/core_ext/object'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'

require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/module/delegation'

require 'java'
require 'jrjackson'
require 'jruby/core_ext'

require 'pathname'

module Murga

  def self.root
    @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
  end

end

require 'murga/version'
require 'murga/config'
require 'murga/handlers/base'
require 'murga/handlers/default'
require 'murga/server'
