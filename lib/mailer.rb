#encoding: UTF-8
def require_all_in(relative_path)
  path = File.expand_path("./#{relative_path}/*.rb", File.dirname(__FILE__))
  Dir.glob(path).each{ |filepath| require filepath }
end
require_all_in('mailer')
