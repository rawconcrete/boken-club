# app/helpers/travel_plans_helper.rb
module TravelPlansHelper
  def status_color_class(status)
    case status
    when 'pending' then 'px-2 py-1 bg-yellow-100 text-yellow-800 rounded'
    when 'completed' then 'px-2 py-1 bg-green-100 text-green-800 rounded'
    when 'cancelled' then 'px-2 py-1 bg-red-100 text-red-800 rounded'
    else 'px-2 py-1 bg-gray-100 text-gray-800 rounded'
    end
  end
end
