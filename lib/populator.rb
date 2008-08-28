$:.unshift(File.dirname(__FILE__))
require 'populator/model_additions'
require 'populator/factory'
require 'populator/record'

require 'populator/adapters/abstract'
require 'populator/adapters/sqlite'
