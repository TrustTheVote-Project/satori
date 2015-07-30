@bindShowHideButtons = (scope) ->
  $("button[data-target][data-toggle=collapse][data-show-label]", scope).each (i, e) ->
    btn = $(e)
    section = $(btn.data('target'))
    section.on "show.bs.collapse", (ev) -> btn.text(btn.data('hide-label') || 'Hide')
    section.on "hide.bs.collapse", (ev) -> btn.text(btn.data('show-label') || 'Show')

$ ->
  bindShowHideButtons()
