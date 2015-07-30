module ApplicationHelper

  # shows the section row with label and optional show / hide button
  def section_row(title, section_id, options = nil)
    options ||= {}

    state      = (options[:state] || :closed).to_sym
    show_label = options[:show_label] || 'Show'
    hide_label = options[:hide_label] || 'Hide'

    content = [
      content_tag(:div, content_tag(:h4, title), class: 'col-sm-11')
    ]

    if state != :always_open
      content << content_tag(:div, content_tag(:button, state == :opened ? hide_label : show_label, :class => 'btn btn-xs btn-default', :type => 'button', :data => { show_label: show_label, hide_label: hide_label, toggle: 'collapse', target: "##{section_id}" }, "aria-expanded" => false, "aria-controls" => section_id), class: 'col-sm-1 text-right')
    end

    content_tag(:div, content.join.html_safe, class: 'row section-row')
  end

end
