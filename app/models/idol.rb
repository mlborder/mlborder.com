class Idol < ActiveHash::Base
  include ActiveHash::Associations
  has_many :event_prizes, class_name: 'Event::Prize'

  fields :id, :key

  Rubimas::Idol.config.keys.map do |key|
    idol = 765.pro.send(key)
    create id: idol.idol_id, key: key
  end

  def method_missing(name)
    765.pro.send(self.key).send(name)
  end
end
