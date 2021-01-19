
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
      puts value
      appt = @appointments.find { |a| a[:id] == value.first[:slot_id] }
      result << "#{value.first[:start]} - #{value.last[:end]} - #{appt[:name]}\n"
    end
    result + "\n"
  end



  private


  def time_slots
    require 'time'
    arr= []

    newdatetime=[]
    (0..15).each_with_index do |a,i|
      thirty_minutes_step = (1.to_f/24/2)
      date_time = DateTime.parse('9:00 AM')
      date_time_limit = DateTime.parse('5:00 PM')

      date_time.step(date_time_limit,thirty_minutes_step).each{|e| newdatetime <<  e.strftime("%I:%M %p")}

      arr<< {id: "#{i}", starttime: "#{newdatetime[i]}", endtime: "#{newdatetime[i+1]}", slot_id: nil }
    end

    @time_slots = arr

  end


  def padding_appointments
    @appointments.each { |appointment|  appointment[:padding] = appointment[:type] == :offsite ? 0.5 : 0 }

  end

  def book_slot(appointment)
    no_of_slots = ((appointment[:duration] + appointment[:padding]) / 0.5).to_i

    if  empty_slots.length > no_of_slots
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



example1 = [
  { id: 1, name: 'Meeting 1', duration: 1.5, type: :onsite },
  { id: 2, name: 'Meeting 2', duration: 2, type: :offsite },
  { id: 3, name: 'Meeting 3', duration: 1, type: :onsite },
  { id: 4, name: 'Meeting 4', duration: 1, type: :offsite },
  { id: 5, name: 'Meeting 5', duration: 1, type: :offsite }
]

example2 = [
  { id: 1, name: 'Meeting 1', duration: 3, type: :offsite },
  { id: 2, name: 'Meeting 2', duration: 4, type: :offsite }
]

example3 = [
  { id: 1, name: 'Meeting 1', duration: 0.5, type: :offsite },
  { id: 2, name: 'Meeting 2', duration: 0.5, type: :onsite },
  { id: 3, name: 'Meeting 3', duration: 2.5, type: :offsite },
  { id: 4, name: 'Meeting 4', duration: 3, type: :onsite }
]

[example1, example2, example3].each_with_index do |example, i|
  puts "Example  #{i + 1}"
  meeting = Meeting.new(example)
  if meeting.validate_meeting
    puts 'Yes, it can fit. One possible solution would be:'
    puts meeting.show
  else
    puts "No, it can’t fit."
  end
end




