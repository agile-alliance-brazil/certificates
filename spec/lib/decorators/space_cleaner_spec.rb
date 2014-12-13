#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::SpaceCleaner do
  subject{ Decorators::SpaceCleaner.new }
  it 'should decorate remove empty spaces from parameter' do
    expect(subject.decorate(" file\t\n  line")).to eq('fileline')
  end
end
