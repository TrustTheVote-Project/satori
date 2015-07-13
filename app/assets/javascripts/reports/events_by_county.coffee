$ ->
  return if ("body#reports_events_by_county").length == 0

  $('#report').dataTable
    paging:  false
    scrollY: 400
    scrollX: true
    info:    false
    searching:  false
