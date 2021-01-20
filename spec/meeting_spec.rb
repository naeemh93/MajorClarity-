require './meeting'

RSpec.describe Meeting do

  context '#validate_meeting' do

    it 'should return true for meetings  that are fit ' do
      appointments = [{ id: 1, name: 'Meeting 1', duration: 1, type: :onsite }]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq true
    end

    it 'should return false for meetings that are not  fit' do
      appointments = []
      schedule = Meeting.new(appointments)
      9.times { |i| appointments << { id: i, name: "Meeting #{i}", duration: 1, type: :onsite } }
      expect(schedule.validate_meeting).to eq false
    end

    it 'should handle padding for offsite appointments' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 4, type: :offsite },
        { id: 2, name: 'Meeting 2', duration: 4, type: :offsite }
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq false
    end

  end

  context 'passing example test' do
    it 'Given a set of meetings (below is an example of a set of meetings):' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 3, type: :onsite },
        { id: 2, name: 'Meeting 2', duration: 2, type: :offsite },
        { id:3, name:  'Meeting 3', duration: 1,  type: :offsite}
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq true
    end

    it 'Given set of meetings for  offsite' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 4, type: :offsite },
        { id: 2, name: 'Meeting 2', duration: 4, type: :offsite }
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq false
    end

  end

end