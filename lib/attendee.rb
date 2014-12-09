#encoding: UTF-8
class Attendee
  def self.conference_name=(name)
    @@conference_name = name
  end
  def self.svg_model=(model)
    @@svg_model = model
  end
  def self.certificate_folder_path=(path)
    @@folder_path = path
  end
  def self.inkscape_path=(path)
    @@inkscape_path = path
  end
  def self.base_body=(body)
    @@body = body
  end

  attr_reader :name, :email
  def initialize(names, email)
    @name = names.map(&:split).flatten.map(&:strip).map(&:capitalize).join(' ')
    @email = email
  end
  def message
    "Caro(a) #{name},\n" + @@body
  end
  def certificate
    svg_filename = generate_svg
    system("#{@@inkscape_path} -T -f #{svg_filename} -A #{filename}")
    File.delete(svg_filename)
    File.read(filename)
  end
  def filename
    File.join(@@folder_path, "#{naming}.pdf")
  end
  private
  def generate_svg
    svg_certificate = @@svg_model.gsub(/&lt;nome_do_participante&gt;/, name)
    file_name = File.join(@@folder_path, "#{naming}.svg")
    File.open(file_name, "w") {|f| f.write(svg_certificate)}
    file_name
  end
  def naming
    filename = "Certificado-"
    filename += "#{@@conference_name}-" if @@conference_name
    filename += @name.gsub(/\s/,"")
    filename
  end
end
