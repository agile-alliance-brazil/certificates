# encoding:UTF-8

describe Certificator::Decorators::Multi do
  let(:decorator1) { Certificator::Decorators::PrependText.new('first-') }
  let(:decorator2) { Certificator::Decorators::PrependText.new('second-') }

  it 'should decorate text through each decorator in order' do
    decorator = Certificator::Decorators::Multi.new(decorator1, decorator2)
    expect(decorator.decorate('file')).to eq('second-first-file')
  end

  it 'should ignore nil decorators' do
    subject = Certificator::Decorators::Multi.new(decorator1, nil, decorator2)
    expect(subject.decorate('file')).to eq('second-first-file')
  end

  it 'should accept arrays of decorators' do
    subject = Certificator::Decorators::Multi.new(decorator1, [nil, decorator2])
    expect(subject.decorate('file')).to eq('second-first-file')
  end

  it 'should accept single nested array' do
    subject = Certificator::Decorators::Multi.new([decorator1, [nil, decorator2]])
    expect(subject.decorate('file')).to eq('second-first-file')
  end
end
