class Date
   def advance_to_day new_day
     if new_day > day
       change(day: new_day)
     elsif new_day < day
       change(day: new_day, month: next_month.month, year: next_month.year)
     else
       self
     end
   end
end