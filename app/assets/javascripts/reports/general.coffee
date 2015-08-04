$ ->
  dt = $('table.dataTable').dataTable
    paging:  false
    scrollY: 400
    scrollX: true
    info:    false
    searching:  false
    bSortCellsTop: true

  new $.fn.dataTable.FixedColumns(dt)
