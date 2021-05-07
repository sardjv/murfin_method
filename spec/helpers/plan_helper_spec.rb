require 'rails_helper'

describe Plan do
  describe 'plan_signoff_options' do
    let(:user1) { create :user, first_name: 'Frank', last_name: 'Foobar' }
    let!(:plan) { create :plan, user: user1 }

    let!(:user2) { create :user, first_name: 'Artur', last_name: 'Lorem' } # lead of user' group
    let!(:user3) { create :user, first_name: 'Barbara', last_name: 'Ipsum' } # lead of user' group
    let!(:user4) { create :user, first_name: 'Anthony', last_name: 'Bar' } # lead but some other users' group
    let!(:user5) { create :user, first_name: 'Andy', last_name: 'Foo' } # member of user' group
    let!(:user6) { create :user, first_name: 'Deborah', last_name: 'Lorem' } # user not member of any group

    let(:user_group1) { create :user_group, users: [user1] }
    let(:user_group2) { create :user_group }
    let(:user_group3) { create :user_group, users: [user1] }
    let(:user_group4) { create :user_group, users: [user1] }

    let!(:lead_membership1) { create :membership, user_group: user_group1, user: user2, role: 'lead' }
    let!(:lead_membership2) { create :membership, user_group: user_group3, user: user3, role: 'lead' }
    let!(:lead_membership3) { create :membership, user_group: user_group2, user: user4, role: 'lead' } # other user' group
    let!(:member_membership1) { create :membership, user_group: user_group4, user: user5, role: 'member' }

    it 'orders by user group leads first than by last and first name' do
      expect(helper.plan_signoff_options(plan)).to eql [
        ['Barbara Ipsum', user3.id],
        ['Artur Lorem', user2.id],
        ['Anthony Bar', user4.id],
        ['Andy Foo', user5.id],
        ['Frank Foobar', user1.id],
        ['Deborah Lorem', user6.id]
      ]
    end
  end
end
