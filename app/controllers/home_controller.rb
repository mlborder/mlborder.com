class HomeController < ApplicationController
  def enjoy_harmony
    @event = Event.at('2015-05-29 17:00:00 +0900')
    return redirect_to events_path if @event.nil?

    @event.series_name ||= ENV['MLBORDER_ENJOY_HARMONY_SERIES_NAME']
    @dataset = @event.border.dataset if @event.has_border?

    render template: 'events/show'
  end
end
