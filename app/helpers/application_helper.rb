# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_flash_class(type)
    case type
    when 'notice' then 'alert-primary'
    when 'alert' then 'alert-danger'
    when 'success' then 'alert-success'
    when 'info' then 'alert-info'
    when 'warning' then 'alert-warning'
    else 'alert-secondary'
    end
  end
end
