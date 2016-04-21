require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.fail_fast = true

  config.platform = 'centos'
  config.version = '6.7'
end

def data_bag_stubs(server)
  cookbook_root = File.expand_path('../../', __FILE__)
  data_bag_path = File.join(cookbook_root, 'test/fixtures/data_bags')
  Dir[File.join(data_bag_path, '*')].map do |d|
    json = read_data_bag(d)
    server.create_data_bag(File.basename(d), json)
  end
end

def read_data_bag(path)
  json = Dir[File.join(path, '*.json')].map { |f| JSON.parse(File.read(f)).to_hash }.flatten
  # rubocop:disable Style/Semicolon
  {}.tap { |h| json.each { |a| nh = a.dup; h[nh['id']] = nh } }
  # rubocop:enable Style/Semicolon
end
