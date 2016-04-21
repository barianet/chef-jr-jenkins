require 'spec_helper'

describe service('jenkins') do
  it 'is listening on port 8080' do
    expect(port(8080)).to be_listening
  end

  it 'has a running service of jenkins' do
    expect(service('jenkins')).to be_running
  end
end
