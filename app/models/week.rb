class Week < ActiveHash::Base
  include ActiveHash::Associations
  fields :id, :start_date

  VERY_BEGINNING_DATE = Date.new(2015, 12, 28).beginning_of_week
  max_week_id = ENV['MAX_WEEK_ID'].try(:to_i) || 12

  (1..max_week_id).each do |id|
    create id: id, start_date: (VERY_BEGINNING_DATE + (id - 1).weeks).beginning_of_week
  end

  def self.find_by_ymd(ymd)
    return unless ymd

    date = Date.strptime(ymd, '%Y%m%d')
    days = (date - VERY_BEGINNING_DATE).to_i
    return if days < 0

    self.find(((days + 1) / 7.0).ceil)
  rescue ArgumentError
  end

  def idol_records(page_num = 0)
    par = IdolRecord.page2offlim(page_num)
    IdolRecord.get("weeks/#{self.id}/idol_records?#{URI.encode_www_form(par)}")
  end

  def player_records(page_num = 0, idol_id: nil)
    par = PlayerRecord.page2offlim(page_num).merge({idol_id: idol_id}).compact
    PlayerRecord.get("weeks/#{self.id}/player_records?#{URI.encode_www_form(par)}")
  end

  def to_ymd
    self.start_date.strftime('%Y%m%d')
  end

  def format_term
    "#{self.start_date.strftime('%Y/%m/%d')}〜#{(self.start_date + 6.days).strftime('%Y/%m/%d')}"
  end
end
