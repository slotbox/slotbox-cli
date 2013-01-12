require "rubygems"
require 'slotbox'

# I can't believe this runs *every* time *any* (yes, any) gem is unisntalled
# And that it isn't documented!
Gem.post_uninstall do |uninstaller|
  if uninstaller.spec.name == 'slotbox'
    puts "Uninstalling Slotbox-Heroku plugin..."
    system "rm -rf #{Slotbox::PLUGIN_DIR}"
    puts "Slotbox-Heroku plugin uninstalled."
  end
end