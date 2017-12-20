Time::DATE_FORMATS[:date] = "%m/%d/%Y"
Date::DATE_FORMATS[:date] = "%m/%d/%Y"

Time::DATE_FORMATS[:default] = "%m/%d/%Y %H:%M"
Time::DATE_FORMATS[:sign] = "%h %d, %Y %I:%M%p"

Time::DATE_FORMATS[:short] = "%m/%d/%y"
Date::DATE_FORMATS[:short] = "%m/%d/%y"

#in email list
Time::DATE_FORMATS[:short_in_day] = "%H:%M"
Time::DATE_FORMATS[:short_in_date] = "%m/%d/%Y"



module ActiveRecordBaseExtension

  def where_if(*args)
    if cond = args.first
      where(*args[1..-1])
    else
      where(nil)
    end
  end

  def where_id(ids)
    self.where(self.primary_key => ids)
  end

  def where_or(*queries)
    sql = queries.map(&:to_sql).join("\nor\n")
    self.where_id(sql)
  end

  def where_like(opt)
    col, value = opt.first
    self.where("#{col} like ?", "%#{value}%")
  end

  def hash_by(&method)
    self.where("").map{|i| [method.call(i), i]}.to_h
  end

  def hash_group_by(&method)
    hash = {}
    self.where("").map do |i|
      k = method.call(i)
      hash[k] ||= []
      hash[k] << i
    end
    hash
  end

end
ActiveRecord::Base.extend ActiveRecordBaseExtension


require 'will_paginate/array'
