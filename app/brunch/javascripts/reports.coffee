$ ->
  dt = $('table.dataTable').dataTable
    paging:         false
    scrollY:        600
    scrollX:        true
    info:           false
    ordering:       false
    searching:      false
    bSortCellsTop:  true

  new $.fn.dataTable.FixedColumns(dt)
