# frozen_string_literal: true

describe Certificator::InkscapeConverter do
  subject(:converter) { Certificator::InkscapeConverter.new('inkscape') }

  it 'should convert files using temp files' do
    svg_file = double('SVG Tempfile')
    expect(svg_file).to receive(:write).with('svg')
    expect(svg_file).to receive(:close)

    pdf_file = double('PDF Tempfile')
    expect(Tempfile).to receive(:new)
      .with('temporary.svg').and_return(svg_file)
    expect(Tempfile).to receive(:new)
      .with('temporary.pdf').and_return(pdf_file)

    expect(svg_file).to receive(:path).and_return('temporary.svg')
    expect(pdf_file).to receive(:path).and_return('temporary.pdf')
    expect(converter).to receive(:system)
      .with('inkscape -T -f temporary.svg -A temporary.pdf')

    expect(pdf_file).to receive(:read).and_return('my pdf')

    expect(svg_file).to receive(:unlink)
    expect(pdf_file).to receive(:unlink)

    expect(converter.convert_to_pdf('svg')).to eq('my pdf')
  end
end
