require 'slotbox'

Dir[File.dirname(__FILE__) + '/lib/slotbox/**/*.rb'].each do |file|
  file.gsub!("plugin/lib/", "")
  require file
end
