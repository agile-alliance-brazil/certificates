#encoding: UTF-8
class Attendee
  attr_reader :attributes

  def initialize(attributes)
    @attributes = Hash[attributes.map{|k,v| [k.to_s, v]}]
  end

  def respond_to_missing?(method, include_private = false)
    @attributes.keys.include?(method.to_s)
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      @attributes[method.to_s]
    else
      super
    end
  end
end
