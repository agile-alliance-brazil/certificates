# encoding:UTF-8

describe Certificator::Decorators::EventPdfCertificate do
  describe 'with prefix' do
    subject(:decorator) do
      Certificator::Decorators::EventPdfCertificate.new('short-file-id-name')
    end

    it 'should decorate filename with id' do
      expect(
        decorator.decorate(
          'id' => 1,
          'name' => 'test'
        )
      ).to eq('short-file-1-test.pdf')
    end

    it 'should decorate remove spaces with event name' do
      expect(
        decorator.decorate(
          'id' => " 1   \n",
          'name' => "\t test "
        )
      ).to eq('short-file-1-test.pdf')
    end
  end

  describe 'without prefix' do
    subject(:decorator) do
      Certificator::Decorators::EventPdfCertificate.new(nil)
    end

    it 'should skip prefix if nil' do
      expect(
        decorator.decorate(
          'id' => 1,
          'name' => 'test'
        )
      ).to eq('1.pdf')
    end

    it 'should decorate remove spaces' do
      expect(
        decorator.decorate(
          'id' => "  1 \t  \n  ",
          'name' => 'test'
        )
      ).to eq('1.pdf')
    end
  end
end
