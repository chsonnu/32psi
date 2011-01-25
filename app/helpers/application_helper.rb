module ApplicationHelper
  def title
    base_title = "32 psi"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    # image_tag("logo.png", :alt => "Sample App", :class => "round")
    link_to "32 psi (logo)", root_path, :class => "logo"
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
