# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::AppendText do
  subject(:decorator) { Decorators::AppendText.new('-appendix') }

  it 'should decorate text appending parameter' do
    expect(decorator.decorate('file')).to eq('file-appendix')
  end
end
