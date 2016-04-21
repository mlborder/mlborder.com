class DramacdThemesController < ApplicationController
  def index
    @themes = DramacdTheme.all
    latest, previous = @themes.first.vote_progress.with_previous
    @previous_vote = previous[:values]
    @latest_vote = latest[:values]
    @previous_updated = previous[:time]
    @latest_updated = latest[:time]
  end
end
