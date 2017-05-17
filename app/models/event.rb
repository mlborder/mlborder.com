# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  event_type_id     :integer
#  name              :string(255)      not null
#  event_type        :integer          default("unknown_event")
#  series_name       :string(255)
#  started_at        :datetime         not null
#  ended_at          :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  records_available :boolean          default(FALSE), not null
#

class Event < ApplicationRecord
  ULA_FINAL_EVENT_ID = 136
  ULA_FINAL_TEAM_SERIES_NAME = '20161021-20161030_ula-team'

  has_many :final_borders
  has_many :alarms
  has_many :prizes, class_name: Event::Prize
  accepts_nested_attributes_for :prizes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :series_name, uniqueness: true, if: 'series_name.present?'
  validate :end_comes_after_start
  validate :periods_are_not_included_by_other
  validate :not_cover_other_one

  paginates_per 25

  scope :border_available, -> { where.not( series_name: nil ) }
  scope :records_available, -> { where( records_available: true ) }

  enum event_type: [
    :unknown_event,
    :raid_event,
    :hhp_event,
    :imc_event,
    :choco_event,
    :lesson_event,
    :psl_event,
    :caravan_event,
    :battle_event,
    :ula_event,
    :nplive_event,
    :imce_event,
    :budokan_event,
  ]

  def has_border?
    series_name.present?
  end

  def border(name = nil)
    name ||= series_name
    @border ||= {}
    return @border[name] if @border[name].present?
    @border[name] = Event::Border.new(self, name)
  end

  def ula_final?
    id == ULA_FINAL_EVENT_ID
  end

  def records(page_num = 0, idol_id = nil)
    return [] unless records_available?
    par = Record.page2offlim(page_num)
    par.merge!({'idol_id' => idol_id}) if idol_id
    Record.get("events/#{self.id}/records?#{URI.encode_www_form(par)}")
  end

  def duration
    self.ended_at - self.started_at
  end

  def days
    (self.duration.to_f / 86400).ceil
  end

  def preparing?
    Time.now < self.started_at
  end

  def started?
    Time.now >= self.started_at
  end

  def ended?
    Time.now >= self.ended_at
  end

  def in_session?
    (self.started_at..self.ended_at).cover? Time.now
  end

  def same_type_previous
    event_type = self.event_type
    Event.border_available.send(event_type).where(Event.arel_table[:ended_at].lteq(self.started_at)).order(id: :desc).first
  end

  def update_final_border_info!(rank = 1200)
    return unless self.has_border?
    return unless self.ended?

    self.final_borders.find_or_initialize_by(rank: rank).tap do |final_border|
      final_border.point = self.border.dataset.last["border_#{rank}"]
      final_border.save!
    end
  end

  def default_series_name
    "#{self.started_at.strftime('%Y%m%d')}-#{self.ended_at.strftime('%Y%m%d')}_#{self.event_type.sub('_event', '')}"
  end

  def format_period
    "#{self.started_at.strf_mlevent}〜#{self.ended_at.strf_mlevent}, #{self.days} days"
  end

  def self.at(time = Time.now)
    time = Time.parse(time) if time.class == String
    where(arel_table[:started_at].lteq(time)).
    where(arel_table[:ended_at].gteq(time)).first
  end

  def self.dump_seeds
    events = self.order(id: :asc).map do |ev|

      prizes_attributes = \
        if ev.prizes.any?
          prize_list = ev.prizes.map do |pz|
            <<~PRIZE_SEED.indent(2).chomp
            { idol_id: #{pz.idol_id} }, \# #{pz.idol.name}
            PRIZE_SEED
          end
          "prizes_attributes: [\n#{prize_list.join("\n")}\n]"
        end

      <<~EVENT_SEED.indent(2).chomp
      { name: '#{ev.name}',
        event_type: '#{ev.event_type}',
        started_at: '#{ev.started_at.in_time_zone('Asia/Tokyo').strftime('%Y-%m-%d %H:%M:%S %z')}',
        ended_at: '#{ev.ended_at.in_time_zone('Asia/Tokyo').strftime('%Y-%m-%d %H:%M:%S %z')}'#{prizes_attributes ? ",\n#{prizes_attributes.indent(2)}\n" : "\n"}}
      EVENT_SEED
    end

    <<~SEED_RB
    Event.create([
    #{events.join(",\n")}
    ])
    SEED_RB
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
