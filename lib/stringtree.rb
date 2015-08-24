files = [
  'version',
  'node',
  'item',
  'tree',
].each { |file| require "#{File.dirname(__FILE__)}/stringtree/#{file}" }
