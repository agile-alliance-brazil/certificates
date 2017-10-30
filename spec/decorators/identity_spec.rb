describe Certificator::Decorators::Identity do
  subject(:decorator) { Certificator::Decorators::Identity.new }

  it 'should return text as given' do
    expect(decorator.decorate('file')).to eq('file')
  end
end
