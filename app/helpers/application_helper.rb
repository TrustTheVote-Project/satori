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

  # renders the error block for a given object with the custom head message
  def form_errors_panel(objects, message, options = {})
    errors = []
    if objects.present?
      [ objects ].flatten.compact.each { |o| errors += o.errors.full_messages }
    end
    hidden_class = errors.any? ? nil : 'hidden'

    content_tag(:div, [
      content_tag(:div, [
        content_tag(:h4, message, class: 'panel-title')
      ].join.html_safe, class: 'panel-heading'),
      content_tag(:div, [
        content_tag(:ul, errors.map { |m| content_tag(:li, m) }.join.html_safe)
      ].join.html_safe, class: 'panel-body')
    ].join.html_safe, class: [ 'panel panel-danger errors', hidden_class, options[:class] ].compact.join(' '))
  end

end
