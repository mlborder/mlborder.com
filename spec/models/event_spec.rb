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

require 'rails_helper'

describe Event do
  it 'should have proper factory' do
    expect(build(:event)).to be_valid
  end

  describe 'validation' do
    specify { expect(build(:event)).to be_valid }
    specify { expect(build(:event, name: '')).not_to be_valid }
    specify { expect(build(:event, started_at: nil)).not_to be_valid }
    specify { expect(build(:event, ended_at: nil)).not_to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-07 18:00:00 +0900')).to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-07 17:00:00 +0900')).not_to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 18:00:00 +0900', ended_at: '2015-01-07 17:00:00 +0900')).not_to be_valid }
    specify { expect(build(:event, series_name: nil)).to be_valid }
    specify { expect(build(:event, series_name: 'psl4th')).to be_valid }
    it 'should have unique series_name' do
      create(:event, series_name: 'psl4th')
      expect(build(:event, series_name: 'psl4th')).not_to be_valid
    end

    describe 'event term must not cover other one.' do
      before do
        @event = create(:event, name: '大成！プラチナスターライブ4TH', series_name: 'psl4th', started_at: '2015-01-16 17:00:00 +0900', ended_at: '2015-01-27 23:59:59 +0900')
      end
      specify { expect(@event).to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-14 23:59:59 +0900')).to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-17 00:00:00 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-17 00:00:00 +0900', ended_at: '2015-01-25 00:00:00 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-25 18:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-29 17:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).to be_valid }
    end
  end

  describe 'decision of has border' do
    specify { expect(build(:event, series_name: nil).has_border?).to be false }
    specify { expect(build(:event, series_name: '20150116-0127_psl4').has_border?).to be true }
  end

  describe 'border_available scope' do
    before :all do
      @event1 = create(:event, name: '開幕！アイドルイントロダクション', series_name: 'introduction')
      @event2 = create(:event, name: '開演！ロケットスタートライブ!', series_name: nil)
      @event3 = create(:event, name: '輝け！春の野外音楽フェスティバル', series_name: 'festival')
    end
    subject { Event.border_available }

    specify { should have(2).items }
    specify { should include @event1 }
    specify { should include @event3 }
  end

  describe 'find by the time' do
    before do
      @imc = create(:event, name: 'アイドルマスターズカップ8', started_at: '2014-12-10 17:00:00 +0900', ended_at: '2014-12-14 23:59:59 +0900')
      @fes = create(:event, name: '神vs魔！ホーリーナイトラウンド', started_at: '2014-12-16 17:00:00 +0900', ended_at: '2014-12-24 23:59:59 +0900')
      @psl = create(:event, name: '大成！プラチナスターライブ4TH', started_at: '2015-01-16 17:00:00 +0900', ended_at: '2015-01-27 23:59:59 +0900')
    end

    context 'specify target time' do
      it 'raise ArgumentError with bad time format' do
        expect{Event.at('bad time format')}.to raise_error(ArgumentError)
      end

      context 'when there is something' do
        it { expect(Event.at('2014-12-10 17:00:00 +0900')).to eq @imc }
        it { expect(Event.at('2014-12-24 23:59:59 +0900')).to eq @fes }
        it { expect(Event.at('2015-01-17 02:32:28 +0900')).to eq @psl }
      end
      context 'when there is no events' do
        it { expect(Event.at('2014-12-10 16:59:59 +0900')).to be_nil }
        it { expect(Event.at('2014-12-15 00:00:00 +0900')).to be_nil }
        it { expect(Event.at('2015-02-05 00:00:00 +0900')).to be_nil }
      end
    end

    context 'not specify target time' do
      subject { Event.at }
      around(:example) { |ex| Timecop.freeze(now) { ex.run } }

      context 'when there is no event for now' do
        let(:now) { '2015-12-10 10:00:00 +0900' }
        it { should be_nil }
      end
      context 'when now is PSL term' do
        let(:now) { '2015-01-16 17:00:00 +0900' }
        it { should eq @psl }
      end
    end
  end

  describe 'previous same type event' do
    before do
      @lesson_event0 = create(:event, event_type: 'lesson_event', series_name: nil)
      @raid_event0 = create(:event, event_type: 'raid_event', series_name: 'event2')
      @lesson_event1 = create(:event, event_type: 'lesson_event', series_name: 'event3')
      @raid_event1 = create(:event, event_type: 'raid_event', series_name: 'event4')
      @raid_event2 = create(:event, event_type: 'raid_event', series_name: nil)
      @raid_event3 = create(:event, event_type: 'raid_event', series_name: 'event5')
    end

    it { expect(@lesson_event0.same_type_previous).to be_nil }
    it { expect(@raid_event0.same_type_previous).to be_nil }
    it { expect(@lesson_event1.same_type_previous).to be_nil }
    it { expect(@raid_event1.same_type_previous).to eq @raid_event0 }
    it { expect(@raid_event2.same_type_previous).to eq @raid_event1 }
    it { expect(@raid_event3.same_type_previous).to eq @raid_event1 }
  end
end
