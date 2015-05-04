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
end
