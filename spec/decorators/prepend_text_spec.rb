describe Certificator::Decorators::PrependText do
  subject(:decorator) { Certificator::Decorators::PrependText.new('suffix-') }

  it 'should decorate text prepending parameter' do
    expect(decorator.decorate('file')).to eq('suffix-file')
  end
end
