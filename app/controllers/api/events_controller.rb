class Api::EventsController < ApiController
  def show
    @event = params[:id] ? Event.find(params[:id]) : Event.border_available.last
    if @event.has_border?
      @border = @event.border.latest
      @before_border = @event.border.border_with_velocity.last
    end
  end
end
