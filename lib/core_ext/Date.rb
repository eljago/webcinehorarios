class Date
   def advance_to_day new_day
     if new_day > 0 && new_day <= 31
       date = Date.new(year, month, day)
       while date.day != new_day
         date += 1
       end
       return change(day: date.day, month: date.month, year: date.year)
     end
     self
   end
end