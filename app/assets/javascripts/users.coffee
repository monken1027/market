ready = ->
  $(document).trigger('refresh_autonumeric')
$(document).ready(ready)
$(document).on('page:load', ready)
