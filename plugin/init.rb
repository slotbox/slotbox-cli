Dir['plugin/lib/slotbox/**/*.rb'].each do |file|
  file.gsub!("plugin/lib/", "")
  require file
end
