#encoding: UTF-8
class Attendee
  attr_reader :name, :email
  def initialize(names, email)
    @name = Array(names).flatten.map(&:strip).map(&:capitalize).join(' ')
    @email = email
  end
end
