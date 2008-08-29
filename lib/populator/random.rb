module Populator
  module Random
    def value_in_range(range)
      case range.first
      when Integer then number_in_range(range)
      when Time then time_in_range(range)
      when Date then date_in_range(range)
      else range.to_a.rand
      end
    end
    
    private
    
    def time_in_range(range)
      Time.at number_in_range(Range.new(range.first.to_i, range.last.to_i, range.exclude_end?))
    end
    
    def date_in_range(range)
      Date.jd number_in_range(Range.new(range.first.jd, range.last.jd, range.exclude_end?))
    end
    
    def number_in_range(range)
      if range.exclude_end?
        rand(range.last - range.first) + range.first
      else
        rand((range.last+1) - range.first) + range.first
      end
    end
  end
  
  extend Random # load it into the populator module directly so we can call the methods
end
