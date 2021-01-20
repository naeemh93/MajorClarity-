require './meeting'

RSpec.describe Meeting do

  context '#validate_meeting' do

    it 'should return true for meetings  that are fit ' do
      appointments = [{ id: 1, name: 'Meeting 1', duration: 1, type: :onsite }]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq 'Yes Can Fit'
    end

    it 'should return false for meetings that are not  fit' do
      appointments = []
      schedule = Meeting.new(appointments)
      9.times { |i| appointments << { id: i, name: "Meeting #{i}", duration: 1, type: :onsite } }
      expect(schedule.validate_meeting).to eq 'No Cant Fit'
    end

    it 'should handle padding for offsite appointments' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 4, type: :offsite },
        { id: 2, name: 'Meeting 2', duration: 4, type: :offsite }
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq 'No Cant Fit'
    end

  end

  context 'passing example test' do

    it 'Given a set of meetings & return true if they fit' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 1.5, type: :onsite },
        { id: 2, name: 'Meeting 2', duration: 2, type: :offsite },
        { id: 3, name: 'Meeting 3', duration: 1, type: :onsite },
        { id: 4, name: 'Meeting 4', duration: 1, type: :offsite },
        { id: 5, name: 'Meeting 5', duration: 1, type: :offsite }
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq 'Yes Can Fit'
      expect(schedule.show).to eq "09:00 AM - 10:30 AM - Meeting 1\n10:30 AM - 01:00 PM - Meeting 2\n01:00 PM - 02:00 PM - Meeting 3\n02:00 PM - 03:30 PM - Meeting 4\n03:30 PM - 04:30 PM - Meeting 5\n\n"
      
    end

    it 'Given a set of meeting for onsite:' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 3, type: :onsite },
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq 'Yes Can Fit'
      expect(schedule.show).to eq "09:00 AM - 12:00 PM - Meeting 1\n\n"
    end

    it 'Given set of meetings for  offsite' do
      appointments = [
        { id: 1, name: 'Meeting 1', duration: 4, type: :offsite },
        { id: 2, name: 'Meeting 2', duration: 4, type: :offsite }
      ]
      schedule = Meeting.new(appointments)
      expect(schedule.validate_meeting).to eq 'No Cant Fit'
    end

  end

end