class Event < ActiveRecord::Base
  belongs_to :event_type

  def self.at(time = Time.now)
    time = Time.parse(time) if time.class == String
    where(arel_table[:started_at].lteq(time)).
    where(arel_table[:ended_at].gteq(time)).first
  end
end
