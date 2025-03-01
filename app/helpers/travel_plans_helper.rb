# app/helpers/travel_plans_helper.rb - Bootstrap version
module TravelPlansHelper
  def status_color_class(status)
    case status
    when 'pending' then 'badge bg-warning text-dark'
    when 'completed' then 'badge bg-success'
    when 'cancelled' then 'badge bg-danger'
    else 'badge bg-secondary'
    end
  end
end
