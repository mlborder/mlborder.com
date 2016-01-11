module ApplicationHelper
  def full_title(page_title)
    if page_title.empty?
      service_name
    else
      "#{page_title} | #{service_name}"
    end
  end

  def service_name
    'mlborder.com'
  end
end
