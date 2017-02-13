class PlayerRecord
  include Her::Model

  def self.page2offlim(page_num)
    { 'o' => 50 * [page_num.to_i - 1, 0].max, 'l' => 50 }
  end

  def player
    Player.find(self.player_id)
  end
end
