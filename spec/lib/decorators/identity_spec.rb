#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::Identity do
  subject{ Decorators::Identity.new }
  it 'should return text as given' do
    expect(subject.decorate('file')).to eq('file')
  end
end
