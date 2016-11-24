# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::Identity do
  subject(:decorator) { Decorators::Identity.new }

  it 'should return text as given' do
    expect(decorator.decorate('file')).to eq('file')
  end
end
