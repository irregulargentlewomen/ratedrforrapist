require 'date'

module DateHelper
  def parse_date(date)
    date =~ /\d{4}-\d{1,2}-\d{1,2}/ ? DateTime.strptime(date, '%Y-%m-%d') : nil 
  end

  def year_string_from_date_string(date)
    (x = parse_date(date)) ? x.strftime('%Y') : 'unknown year'
  end
end