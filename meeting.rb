
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
    require 'time'
    @time_slots= []
    newdatetime=[]
    (0..15).each_with_index do |a,i|
      thirty_minutes_step = (1.to_f/24/2)
      date_time = DateTime.parse('9:00 AM')
      date_time_limit = DateTime.parse('5:00 PM')

      date_time.step(date_time_limit,thirty_minutes_step).each{|e| newdatetime <<  e.strftime("%I:%M %p")}

      @time_slots<< {:id=> i, :starttime=> "#{newdatetime[i]}", :endtime=> "#{newdatetime[i+1]}", :slot_id=> nil }
    end
    
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



