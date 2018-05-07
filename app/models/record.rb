class Record
  include Her::Model

  belongs_to :player

  def idol
    Rubimas.find(idol_id.to_i) if idol_id
  end

  def display_name
    name || "Unknown: #{player_id}"
  end

  def self.page2offlim(page_num)
    { 'o' => 50 * [page_num.to_i - 1, 0].max, 'l' => 50 }
  end
end
