module ApplicationHelper

  def title(page_title)
    if Rails.env.development?
      page_title = "LOCAL " + page_title
    end
    content_for (:title) {page_title + " - "}
  end

  def yield_or_default(section, default = "")
    if Rails.env.development?
      default = " LOCAL"
    end
      content_for?(section) ? content_for(section) : default
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil)

  end

  def city_names
    City.all_names
  end

  def ignore_link_text(ignorable)  
    ignorable.ignore? ? 'Ignored' : 'Valid'  
  end

end
