class Event::Prize < ActiveRecord::Base
  belongs_to :event

  def idol
    Idol.find(self.idol_id)
  end
end
