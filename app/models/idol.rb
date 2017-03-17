class Idol < ActiveHash::Base
  include ActiveHash::Associations
  has_many :event_prizes, class_name: 'Event::Prize'

  fields :id, :key

  Rubimas::Idol.all.map do |idol|
    create id: idol.id, key: idol.key
  end

  def method_missing(name)
    765.pro.send(self.key).send(name)
  end
end
