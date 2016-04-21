require 'spec_helper'

describe service('httpd') do
  it 'is listening on port 80' do
    expect(port(80)).to be_listening
  end

  it 'has a running service of httpd' do
    expect(service('httpd')).to be_running
  end
end
