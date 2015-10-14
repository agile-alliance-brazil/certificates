#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe PrawnConverter do
  let(:svg_data) { File.read(File.expand_path('../../fixtures/certificate.svg', File.dirname(__FILE__))) }
  let(:pdf_data) { File.read(File.expand_path('../../fixtures/certificate.pdf', File.dirname(__FILE__))) }
  it 'should convert files using pdf temp file' do
    pdf_file = double('PDF Tempfile')
    expect(Prawn::Document).to receive(:generate).
      with(anything, margin: [0,0,0,0]).and_call_original

    result = subject.convert_to_pdf(svg_data)
    expect(result).to eq(pdf_data)
  end
end
