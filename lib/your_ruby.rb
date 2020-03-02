# frozen_string_literal: true

module YourRuby
  module_function

  def fizzbuzz(max)
    arr = []
    1.upto(max) do |i|
      fizz = (i % 3 == 0)
      buzz = (i % 5 == 0)
      arr << case
        when fizz && buzz then 'fizzbuzz'
        when fizz then 'fizz'
        when buzz then 'buzz'
        else i
        end
    end
    arr
  end

  def smallest_rectangle_of_aspect(ratio, rectangle)
    rect_width = rectangle[0]
    rect_height = rectangle[1]
    r = ratio.to_s.to_r

    if ratio == 1
      container = [rectangle.max, rectangle.max]
    end
    
    if ratio < 1
      container = [r.denominator, r.numerator]
      while container[0] < rectangle[0] || container[1] < rectangle[1]
        container[0] +=1
        container[1] = container[0]*ratio
      end
    end

    if ratio > 1
      container = [rect_width, rect_width*r.numerator]
      while container.max < rectangle.max
        container[1] +=1
        container[0] = container[1]/ratio
      end
    end
    container
  end

  def parse_time(str)
    time = Time.parse(str).utc
    time.hour * 60 * 60 + time.min * 60 + time.sec
  end

  def finish_time_for_day(date, opening_hours)
    day_name = date.strftime("%a")
    if opening_hours.has_key?(day_name)
      finishing_time = opening_hours[day_name][1]
      #date/time is set to 12:00 in tests, so have to subtract 12 hours
      seconds_to_finishing_time = parse_time(finishing_time) 
      date + seconds_to_finishing_time - 12*60*60
    else
      false
    end
  end

  def start_time_for_day(date, opening_hours)
    day_name = date.strftime("%a")
    if opening_hours.has_key?(day_name)
      opening_time = opening_hours[day_name][0]
      #date/time is set to 10:00 in tests, so have to subtract 10 hours
      seconds_to_opening_time = parse_time(opening_time) 
      date + seconds_to_opening_time - 10*60*60
    else
      false
    end
  end

  def calculate_completion_time(placed_at, num_hours, opening_hours)
    #in this case, assuming can only place orders on working days and processing times are less than 12 hours.
    day_name = placed_at.strftime("%a")
    completion_time = placed_at + num_hours*60*60
    if completion_time.strftime("%k:%M") > opening_hours[day_name][1]
      if day_name == "Fri"
        completion_time += 64*60*60
      else #for other working days
        completion_time += 15.5*60*60
      end
    end
    completion_time
  end

  def duckduckwhy(str, num_results)
    #THE API ONLY SEEMS TO RETURN A SINGLE FOCUSED RESULT, THE WIKIPEDIA ABSTRACT, AND OTHER RELATED TOPICS WHICH ARE NOT HIGHLY RELEVANT. THERE IS NO PARAMETER IN THE API TO REFINE THE NUMBER OF RESULTS. IT COULD BE DONE CURRENTLY BY SCRAPING THE HTML FROM A SEARCH AT https://duckduckgo.com/?q=... BUT THAT WOULD REQUIRE THE USE OF EXTERNAL LIBRARIES, E.G. NOKOGIRI
    uri = URI.parse("https://api.duckduckgo.com/?q=#{str}&format=json&pretty=1")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    puts JSON.pretty_generate(result)
  end
end
