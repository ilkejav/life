require "json"
require "date"

class Life

  def name; return "life" end

  def initialize
    @checkins = JSON.load(File.new('Apps/life/check_in.json', 'r'))
    # puts @checkins
  end

  def checkins; return @checkins end

  def run params
    
    command = params.shift

    case command
    when "checkin"
      check_in(params)
      return "tried to check in"
    when "update"
      update_entries
      return "tried to update"
    else
      find_earliest_entry checkins
      return "did not check in"
    end

  end
  
  def check_in data
    
    day = checkins
    now = "#{Time.now.strftime("%B_%d_%Y")}"

    if checkins.key?(now)


      puts "this day already exists!"

    else

      info = Hash.new
      info["weekday"] = "#{Time.now.strftime("%A")}"
      info["wake"] = data.first
      info["sleep"] = data.last
      day[now] = info

      write_to_file day
        
      puts "adding this checkin"
    end

  end

  def update_data

  end

  def earliest_entry data
    return data.keys.min
  end

  def update_entries
    
    old = Date.parse(earliest_entry(checkins))
    # old = Date.parse(oldest)
    now = Date.today
    
    old.upto(now) do |date|

      str = date.strftime("%B_%d_%Y").to_s
      puts str
      
      if checkins.include?(str)
        checkins[str]["weekday"] = "#{date.strftime("%A")}"
        puts "this day exists! not touching it"
      else
        checkins[str] = {"weekday" => "#{date.strftime("%A")}" }
        # checkins[str]["weekday"] = "#{date.strftime("%A")}"  
        puts "adding this day"
      end

    end

    write_to_file checkins

  end

  def write_to_file data
    File.open("Apps/life/check_in.json", "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

end

  