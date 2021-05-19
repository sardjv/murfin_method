describe CsvExport::Users do
  subject { described_class.call(args) }

  let(:user_group1) { create :user_group }
  let(:user_group2) { create :user_group }
  let!(:user1) { create :user, user_groups: [user_group1, user_group2] }
  let!(:user2) { create :admin }

  let(:args) { { users: User.all } }

  it 'returns csv' do
    csv = subject

    data = CSV.parse(csv)
    expect(data[0]).to eql ['First name', 'Last name', 'Email', 'EPR UUID', 'Admin', 'User group names']
    expect(data[1]).to eql [user1.first_name, user1.last_name, user1.email, user1.epr_uuid, 'false',
                            [user_group1.name, user_group2.name].sort.join(',')]
    expect(data[2]).to eql [user2.first_name, user2.last_name, user2.email, user2.epr_uuid, 'true', '']
  end
end
