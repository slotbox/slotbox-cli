# Oh god this is profound hack.
# It would be slightly more acceptable to just override Heroku's display(), error(), ets functions.
# But until the Heroku client is forked to Slotbox this will have to do :(
class IO
  def puts(output="")
    super(output.gsub("heroku", "slotbox"))
  end
end