class DramacdTheme < ActiveHash::Base
  include ActiveHash::Associations

  self.data = [
    { id: 1, title: '任侠映画', raw_idol_role: '風来坊,お嬢,子分,悪徳組長,用心棒' },
    { id: 2, title: '学園ホラー', raw_idol_role: '普通の子,幼なじみ,転校生,部長,霊' },
    { id: 3, title: '剣と魔法のファンタジー', raw_idol_role: '勇者,魔王,妖精,四天王,村人A' }
  ]

  def start_time
    Time.parse('2016-04-18 00:00:00 +0900')
  end

  def end_time
    Time.parse('2016-05-02 09:59:59 +0900')
  end

  def series_name
    'theater_activity_1-3'
  end

  def idol_roles
    self.raw_idol_role.split(',')
  end

  def vote_progress
    @vote_progress ||= DramacdTheme::VoteProgress.new(self)
  end
end
