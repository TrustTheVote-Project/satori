$ ->
  dt = $('table.dataTable').dataTable
    paging:  false
    scrollY: 800
    scrollX: true
    info:    false
    searching:  false
    bSortCellsTop: true

  new $.fn.dataTable.FixedColumns(dt)
