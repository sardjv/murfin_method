describe UserStatsPresenter, freeze: Time.zone.local(2020, 10, 30, 17, 59, 59) do
  subject { UserStatsPresenter.new(args) }

  let(:args) do
    { user: user,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids }
  end

  let(:user) { create :user }
  let(:filter_start_date) { (1.year.ago + 1.day).beginning_of_day }
  let(:filter_end_date) { Time.current.end_of_day }
  let(:tag_type1) { create :tag_type } # active for activities and time ranges
  let(:tag1) { create :tag, tag_type: tag_type1 }

  context 'when user has plan and actual data with tags' do
    let!(:plan) { create :plan, user: user, start_date: filter_start_date, end_date: filter_end_date }

    # planned
    let!(:activity1) { create :activity, plan: plan, seconds_per_week: (4 * 3600) } # 4 hours per week
    let!(:plan_tag_association) { create :tag_association, taggable: activity1, tag: tag1, tag_type: tag1.tag_type }

    # actual
    let(:actual_value1) { 6274 } # 2 hours per week

    let!(:actual1) do
      create :time_range, user_id: user.id,
                          time_range_type_id: TimeRangeType.actual_type.id,
                          start_time: filter_start_date,
                          end_time: filter_end_date,
                          value: actual_value1
    end

    let!(:actual_tag_association) { create :tag_association, taggable: actual1, tag: tag1, tag_type: tag1.tag_type }

    context 'with no filter tag' do
      let(:filter_tag_ids) { [] }

      it 'returns all data' do
        expect(subject.average_weekly_planned).to eq 240.0
        expect(subject.average_weekly_actual).to eq 120.0
        expect(subject.percentage_delivered).to eq 50
      end
    end

    context 'with not related tags' do
      let!(:tag3) { create :tag, tag_type: tag_type1 }
      let!(:tag4) { create :tag, tag_type: tag_type1 }

      let(:filter_tag_ids) { [tag3.id, tag4.id] }

      it 'returns empty stats' do
        expect(subject.average_weekly_planned).to eq nil
        expect(subject.average_weekly_actual).to eq nil
        expect(subject.percentage_delivered).to eq nil
      end
    end

    context 'with filter tag' do
      let(:filter_tag_ids) { [tag1.id.to_s] }

      context 'when planned and actual have tag' do
        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 50
        end
      end

      context 'when plan activity does not have tag' do
        let!(:plan_tag_association) { nil }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq nil
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq nil
        end
      end

      context 'when actual does not have tag' do
        let!(:actual_tag_association) { nil }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq nil
          expect(subject.percentage_delivered).to eq nil
        end
      end
    end

    context 'when have a second plan activity with a different tag' do
      let!(:tag2) { create :tag, name: 'tag2', tag_type: tag_type1 }
      let!(:activity2) { create :activity, plan: plan, seconds_per_week: (3 * 3600) } # 3h
      let!(:plan_tag_association2) { create :tag_association, taggable: activity2, tag: tag2, tag_type: tag2.tag_type }

      context 'when no filter tags' do
        let(:filter_tag_ids) { [] }

        it 'returns all data' do
          expect(subject.average_weekly_planned).to eq 420.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 29
        end
      end

      context 'when filter by one tag' do
        let(:filter_tag_ids) { [tag1.id.to_s] }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 50
        end
      end

      context 'when filter by more than one tag' do
        let(:filter_tag_ids) { [tag1.id.to_s, tag2.id.to_s] }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 420.0 # 4h + 3h
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 29
        end
      end
    end

    context 'when have a second actual with a different tag' do
      let!(:tag2) { create :tag, name: 'tag2', tag_type_id: tag_type1.id }

      let(:actual_value2) { 3137 } # 1 hour per week
      let!(:actual2) do
        create :time_range, user_id: user.id,
                            time_range_type_id: TimeRangeType.actual_type.id,
                            start_time: filter_start_date,
                            end_time: filter_end_date,
                            value: actual_value2
      end
      let!(:actual_tag_association2) { create :tag_association, taggable: actual2, tag: tag2, tag_type: tag2.tag_type }

      context 'when no filter tags' do
        let(:filter_tag_ids) { [] }

        it 'returns all data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 180.0 # 2h + 1h
          expect(subject.percentage_delivered).to eq 75
        end
      end

      context 'when filter by one tag' do
        let(:filter_tag_ids) { [tag1.id.to_s] }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 50
        end
      end

      context 'when filter by more than one tag' do
        let(:filter_tag_ids) { [tag1.id.to_s, tag2.id.to_s] }

        it 'returns filtered data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 180.0
          expect(subject.percentage_delivered).to eq 75
        end
      end
    end
  end
end
