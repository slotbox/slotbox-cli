if ENV['HEROKU_HOST'] =~ /slotbox/

  require 'slotbox'

  Dir[ File.dirname(__FILE__) + '/lib/slotbox/**/*.rb'].each do |file|
    require file
  end

end