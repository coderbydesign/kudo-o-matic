module TeamHelper
  include ActionView::Helpers::TextHelper

  def render_primary_color(team)
    team.primary_color || '#4B4656'
  end

end
