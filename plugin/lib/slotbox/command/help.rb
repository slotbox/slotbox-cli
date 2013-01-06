class Heroku::Command::Help

  def skip_namespace?(ns)
    return true if ns[:description] =~ /DEPRECATED:/
    return true if ns[:description] =~ /HIDDEN:/
    return true if Slotbox::UNSUPPORTED_COMMANDS.include? ns[:name]
    false
  end

end


