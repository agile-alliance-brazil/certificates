# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::SpaceCleaner do
  subject(:decorator) { Decorators::SpaceCleaner.new }

  it 'should decorate remove empty spaces from parameter' do
    expect(decorator.decorate(" file\t\n  line")).to eq('fileline')
  end
end
