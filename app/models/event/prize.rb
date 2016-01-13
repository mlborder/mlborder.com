class Event::Prize < ActiveRecord::Base
  belongs_to :event

  validates :idol_id, presence: true

  def idol
    Idol.find(self.idol_id)
  end
end
