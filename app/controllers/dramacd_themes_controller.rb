class DramacdThemesController < ApplicationController
  def index
    @themes = DramacdTheme.all
    progress = @themes.first.vote_progress.latest
    @latest_vote = progress[:values]
    @latest_updated = progress[:time]
  end
end
