class Idol < ActiveHash::Base
  self.data = Rubimas::Idol.config.values
end
