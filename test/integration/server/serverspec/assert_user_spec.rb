require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe service('jenkins') do

  it 'does not allow connections from anonymous traffic' do
    # @todo
    skip '@todo'
  end

  it "has user 'chef'" do
    # @todo
    skip '@todo'
  end

  it "can authenticate as 'chef'" do
    # @todo
    skip '@todo'
  end

end
