class Dashing.Barchart extends Dashing.Widget

  ready: ->
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    projectFound =  false

    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into ChartBar")
      return
       
    # Get HTML tag
    ctx = $("#chart-bar-area")[0].getContext('2d')

    numberOpenClosedBlue = []
    numberOpenOrange     = []
    numberResolvedGreen  = []
    numberResolvedKoRed  = []

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        numberOpenClosedBlue = projectline.chartBarOpen[0].numberOpenClosed
        numberOpenOrange     = projectline.chartBarOpen[0].numberOpen
        numberResolvedGreen  = projectline.chartBarOpen[0].numberResolved
        numberResolvedKoRed  = projectline.chartBarOpen[0].numberResolvedKo
        break

    # Data
    barChartData = 
      labels: [
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
      datasets: [
        {
          label: 'Open and Closed'
          backgroundColor: window.chartColors.blue
          stack: 'Stack 0'
          data: numberOpenClosedBlue #blue
        }
        {
          label: 'Open (not closed)'
          backgroundColor: window.chartColors.orange
          stack: 'Stack 0'
          data: numberOpenOrange # orange
        }
        {
          label: 'Resolved during the months, SLA OK'
          backgroundColor: window.chartColors.green
          stack: 'Stack 1'
          data: numberResolvedGreen #green
        }
        {
          label: 'Resolved during the months, SLA Missed'
          backgroundColor: window.chartColors.red
          stack: 'Stack 1'
          data: numberResolvedKoRed#Red
        }
      ]

    config =
       type: 'bar'
       data: barChartData
       options:
         plugins: datalabels: color: 'black'
         layout: padding:
           left: 50
           right: 0
           top: 0
           bottom: 0
         title:
           display: true
           text: 'Number of tickets Open/Resolved'
           fontColor: '#FFFFFF'
           fontSize: 15
         legend:
           display: true
           labels:
             fontColor: 'rgb(255, 255, 255)'
             fontSize: 13
         responsive: true
         scales:
           xAxes: [ { stacked: true } ]
           yAxes: [ { stacked: true } ]

    if projectFound
      myChart = new Chart(ctx, config);
      myChart.update();
    else
      console.log("Project is not into the Configuration file - Bar Chart cannot be displayed")
      window.open("../../public/404.html","_self");