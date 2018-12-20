class @Tool

  @getURLParams = ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    #Get only the first parameter
    [key, val] = raw_vars[0].split("=")
    params[key] = decodeURIComponent(val)
    params

  @getMonthName = (position) ->
    months = [
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December'
    ]
    months[position]