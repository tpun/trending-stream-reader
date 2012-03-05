module Aji::AgeFormatter
    def age from=Time.now
      diff = from - self
      return "Just now" if diff==0
      ago_later = if diff > 0 then "ago" else "later" end

      str = ""
      [:weeks, :days, :hours, :minutes, :seconds].each do |time_unit|
        period = 1.send time_unit
        n = Integer diff / period
        str += "#{n.abs}#{time_unit[0]} " if n.abs > 0
        diff -= n * period
      end
      str += ago_later

      str
    end
end

Time.send :include, Aji::AgeFormatter
