#encoding: UTF-8
def require_all_files_in_relative_folder(folder_name)
  caller_file = caller.first.split(/:\d/,2).first
  raise LoadError, "require_relative is called in #{$1}" if /\A\((.*)\)/ =~ caller_file
  dir_path = File.expand_path("#{folder_name}/*.rb", File.dirname(caller_file))
  Dir[dir_path].each{|file| require file}
end
