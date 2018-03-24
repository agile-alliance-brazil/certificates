# frozen_string_literal: true

describe Certificator::Decorators::SpaceCleaner do
  subject(:decorator) { Certificator::Decorators::SpaceCleaner.new }

  it 'should decorate remove empty spaces from parameter' do
    expect(decorator.decorate(" file\t\n  line")).to eq('fileline')
  end
end
