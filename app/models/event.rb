class Event < ActiveRecord::Base
  belongs_to :event_type
  validates :name, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :series_name, uniqueness: true, if: 'series_name.present?'
  validate :end_comes_after_start
  validate :periods_are_not_included_by_other
  validate :not_cover_other_one

  def has_border?
    series_name.present?
  end

  def self.at(time = Time.now)
    time = Time.parse(time) if time.class == String
    where(arel_table[:started_at].lteq(time)).
    where(arel_table[:ended_at].gteq(time)).first
  end

  private
  def end_comes_after_start
    return if errors.present?

    return if self.started_at < self.ended_at
    errors[:base] << 'ended_at must be after started_at'
  end

  def periods_are_not_included_by_other
    return if errors.present?

    period_event_start = Event.at(self.started_at)
    if period_event_start.present? && period_event_start != self
      errors.add(:started_at, 'must not be included other one')
    end

    period_event_end = Event.at(self.ended_at)
    if period_event_end.present? && period_event_end != self
      errors.add(:ended_at, 'must not be included other one')
    end
  end

  def not_cover_other_one
    return if errors.present?

    return if Event.covered_by(self).empty?
    errors[:base] << 'event term must not cover other event'
  end

  def self.covered_by(event)
    where(arel_table[:started_at].gt(event.started_at)).
    where(arel_table[:ended_at].lt(event.ended_at))
  end
end
