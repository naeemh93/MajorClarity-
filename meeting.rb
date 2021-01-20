
class Meeting


  def initialize(appointments)
    @appointments = appointments
    time_slots
  end

  def validate_meeting
     @appointments.sort_by { |appt| appt[:type] }

    padding_appointments
    @appointments.each do |appointment|
      success = book_slot(appointment)
      if !success
        return false
      end
    end
    true
  end

  def show
    return 'There are no appointments.' if @appointments.nil?

    result = ''
    filled_slots.group_by { |s| s[:slot_id] }.each do |key, value|
      appt = @appointments.find { |a| a[:id] == value.first[:slot_id] }
      result << "#{value.first[:start]} - #{value.last[:end]} - #{appt[:name]}\n"
    end
    result + "\n"
  end



  private


  def time_slots
    @time_slots = [
      { id: 0, start: '9:00', end: '9:30', slot_id: nil },
      { id: 1, start: '9:30', end: '10:00', slot_id: nil },
      { id: 2, start: '10:00', end: '10:30', slot_id: nil },
      { id: 3, start: '10:30', end: '11:00', slot_id: nil },
      { id: 4, start: '11:00', end: '11:30', slot_id: nil },
      { id: 5, start: '11:30', end: '12:00', slot_id: nil },
      { id: 6, start: '12:00', end: '12:30', slot_id: nil },
      { id: 7, start: '12:30', end: '1:00', slot_id: nil },
      { id: 8, start: '1:00', end: '1:30', slot_id: nil },
      { id: 9, start: '1:30', end: '2:00', slot_id: nil },
      { id: 10, start: '2:00', end: '2:30', slot_id: nil },
      { id: 11, start: '2:30', end: '3:00', slot_id: nil },
      { id: 12, start: '3:00', end: '3:30', slot_id: nil },
      { id: 13, start: '3:30', end: '4:00', slot_id: nil },
      { id: 14, start: '4:00', end: '4:30', slot_id: nil },
      { id: 15, start: '4:30', end: '5:00', slot_id: nil }
    ]

  end


  def padding_appointments
    @appointments.each { |appointment|  appointment[:padding] = appointment[:type] == :offsite ? 0.5 : 0 }
    @appointments.last[:padding] = 0

  end

  def book_slot(appointment)
    no_of_slots = ((appointment[:duration] + appointment[:padding]) / 0.5).to_i
    if  empty_slots.length >= no_of_slots
      fill_slots(no_of_slots, appointment[:id])
      true
    else
      false
    end
  end

  def fill_slots(number_of_slots, appt_id)
    start_index = empty_slots.first[:id]

    number_of_slots.times { |i|  @time_slots[start_index + i][:slot_id] = appt_id  }
  end

  def empty_slots
     @time_slots.select{|s| s[:slot_id].nil?}
  end

  def filled_slots
    @time_slots.reject { |s| s[:slot_id].nil? }
  end

end



