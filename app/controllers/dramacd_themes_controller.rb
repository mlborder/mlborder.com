class DramacdThemesController < ApplicationController
  def index
    @themes = DramacdTheme.all
    latest, previous = @themes.first.vote_progress.with_previous
    @previous_vote = previous[:values]
    @latest_vote = latest[:values]
    @previous_updated = previous[:time]
    @latest_updated = latest[:time]
  end

  def show
    @theme = DramacdTheme.find(params[:id])

    @@dramacd_cached_dataset ||= {}
    @@dramacd_cached_at ||= nil
    if @@dramacd_cached_at.nil? || (@@dramacd_cached_at < Time.now - 30.minutes)
      @@dramacd_cached_at = Time.now
      @@dramacd_cached_dataset = {}
    end
    @@dramacd_cached_dataset[@theme.id] ||= @theme.vote_progress.dataset
    @dataset = @@dramacd_cached_dataset[@theme.id]
  end
end
