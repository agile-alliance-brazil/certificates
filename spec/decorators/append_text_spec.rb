# encoding:UTF-8

describe Certificator::Decorators::AppendText do
  subject(:decorator) { Certificator::Decorators::AppendText.new('-appendix') }

  it 'should decorate text appending parameter' do
    expect(decorator.decorate('file')).to eq('file-appendix')
  end
end
