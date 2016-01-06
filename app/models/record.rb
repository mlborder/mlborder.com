class Record
  include Her::Model

  belongs_to :player

  def self.page2offlim(page_num)
    { 'o' => 100 * [page_num.to_i - 1, 0].max, 'l' => 100 }
  end
end
