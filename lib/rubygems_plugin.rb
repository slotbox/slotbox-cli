require "rubygems"

slotbox_plugin_dir = "~/.heroku/plugins/slotbox"

Gem.post_install do |installer|
  puts "Installing Slotbox-Heroku plugin..."
  spec = Gem::Specification.find_by_name("slotbox")
  system "mkdir -p #{slotbox_plugin_dir}"
  system "cp -rf #{spec.gem_dir}/plugin/* #{slotbox_plugin_dir}"
  puts "Slotbox-Heroku plugin installed."
end

Gem.post_uninstall do |uninstaller|
  puts "Uninstalling Slotbox-Heroku plugin..."
  system "rm -rf #{slotbox_plugin_dir}"
  puts "Slotbox-Heroku plugin uninstalled."
end