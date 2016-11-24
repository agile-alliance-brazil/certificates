# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::Multi do
  let(:decorator1) { Decorators::PrependText.new('first-') }
  let(:decorator2) { Decorators::PrependText.new('second-') }

  it 'should decorate text through each decorator in order' do
    decorator = Decorators::Multi.new(decorator1, decorator2)
    expect(decorator.decorate('file')).to eq('second-first-file')
  end

  it 'should ignore nil decorators' do
    subject = Decorators::Multi.new(decorator1, nil, decorator2)
    expect(subject.decorate('file')).to eq('second-first-file')
  end

  it 'should accept arrays of decorators' do
    subject = Decorators::Multi.new(decorator1, [nil, decorator2])
    expect(subject.decorate('file')).to eq('second-first-file')
  end

  it 'should accept single nested array' do
    subject = Decorators::Multi.new([decorator1, [nil, decorator2]])
    expect(subject.decorate('file')).to eq('second-first-file')
  end
end
