class IdolRecord
  include Her::Model

  def self.page2offlim(page_num)
    { 'o' => 50 * [page_num.to_i - 1, 0].max, 'l' => 50 }
  end

  def idol
    Idol.find(self.idol_id)
  end
end
