describe UserStatsPresenter, freeze: Time.zone.local(2020, 10, 30, 17, 59, 59) do
  subject { UserStatsPresenter.new(args) }
  let(:args) do
    { user: user,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids }
  end
  let(:user) { create(:user) }
  let(:filter_start_date) { (1.year.ago + 1.day).beginning_of_day }
  let(:filter_end_date) { Time.current.end_of_day }
  let(:tag1) { create(:tag) }

  context 'when user has plan and actual data with tags' do
    let!(:plan) do
      create(:plan, user_id: user.id, start_date: filter_start_date, end_date: filter_end_date)
    end
    # 4 hours per week
    let!(:plan_activity) { create(:activity, plan: plan, seconds_per_week: (4 * 60 * 60)) }
    let!(:plan_tag_association) do
      create(:tag_association, taggable: plan_activity, tag: tag1, tag_type: tag1.tag_type)
    end

    let!(:actual) do
      create(:time_range, user_id: user.id,
                          time_range_type_id: TimeRangeType.actual_type.id,
                          start_time: filter_start_date,
                          end_time: filter_end_date,
                          value: actual_value)
    end
    # 2 hours per week
    let(:actual_value) { 6274 }
    let!(:actual_tag_association) do
      create(:tag_association, taggable: actual, tag: tag1, tag_type: tag1.tag_type)
    end

    context 'with no filter tag' do
      let(:filter_tag_ids) { [] }

      it 'returns all data' do
        expect(subject.average_weekly_planned).to eq 240.0
        expect(subject.average_weekly_actual).to eq 120.0
        expect(subject.percentage_delivered).to eq 50
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
      let(:tag2) { create(:tag) }
      let!(:activity2) { create(:activity, plan: plan, seconds_per_week: (4 * 60 * 60)) }
      let!(:plan_tag_association2) do
        create(:tag_association, taggable: activity2, tag: tag2, tag_type: tag2.tag_type)
      end

      context 'when no filter tags' do
        let(:filter_tag_ids) { [] }

        it 'returns all data' do
          expect(subject.average_weekly_planned).to eq 480.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 25
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
          expect(subject.average_weekly_planned).to eq 480.0
          expect(subject.average_weekly_actual).to eq 120.0
          expect(subject.percentage_delivered).to eq 25
        end
      end
    end

    context 'when have a second actual with a different tag' do
      let(:tag2) { create(:tag) }
      let!(:actual2) do
        create(:time_range, user_id: user.id,
                            time_range_type_id: TimeRangeType.actual_type.id,
                            start_time: filter_start_date,
                            end_time: filter_end_date,
                            value: actual_value)
      end
      let!(:actual_tag_association2) do
        create(:tag_association, taggable: actual2, tag: tag2, tag_type: tag2.tag_type)
      end

      context 'when no filter tags' do
        let(:filter_tag_ids) { [] }

        it 'returns all data' do
          expect(subject.average_weekly_planned).to eq 240.0
          expect(subject.average_weekly_actual).to eq 240.0
          expect(subject.percentage_delivered).to eq 100
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
          expect(subject.average_weekly_actual).to eq 240.0
          expect(subject.percentage_delivered).to eq 100
        end
      end
    end
  end
end
