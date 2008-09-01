$:.unshift(File.dirname(__FILE__))
require 'populator/model_additions'
require 'populator/factory'
require 'populator/record'
require 'populator/random'

require 'populator/adapters/abstract'
require 'populator/adapters/sqlite'

# Populator is made up of several parts. To start, see Populator::ModelAdditions.
module Populator
end
