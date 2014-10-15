require "#{ENV['BUSSER_ROOT']}/../kitchen/data/serverspec_helper.rb"

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
