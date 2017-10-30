describe Certificator::PrawnConverter do
  let(:svg_data) do
    File.read(
      File.expand_path(
        '../fixtures/certificate.svg',
        File.dirname(__FILE__)
      )
    )
  end
  let(:expected_pdf_data) do
    File.read(
      File.expand_path(
        '../fixtures/certificate.pdf',
        File.dirname(__FILE__)
      )
    )
  end

  it 'should convert files using pdf temp file' do
    expect(Prawn::Document).to receive(:generate)
      .with(anything, margin: [0, 0, 0, 0], page_size: [1052, 744])
      .and_call_original

    result = subject.convert_to_pdf(svg_data)
    expect(result).to eq(expected_pdf_data)
  end
end
