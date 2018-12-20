class Dashing.Tickets extends Dashing.Widget

	ready: ->
    # Get all variable 
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart classif current")
      return
    projectFound =  false

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        numberBfNoWar = projectline.chartClassifCurrentMonth.numberBfNoWar
        numberBfWar   = projectline.chartClassifCurrentMonth.numberBfWar
        numberDataReq = projectline.chartClassifCurrentMonth.numberDataReq
        numberSupport = projectline.chartClassifCurrentMonth.numberSupport
        numberUnknown = projectline.chartClassifCurrentMonth.numberUnknown
        break

    # Determine the current month
    classif_title = 'Classification for '	+ Tool.getMonthName((new Date).getMonth())

    # Get HTML tag
    ctx = $("#chart-classif-current-area")[0].getContext('2d')
    config = 
      type: 'doughnut'
      data:
        datasets: [ {
          data: [
            numberBfNoWar
            numberBfWar
            numberDataReq
            numberSupport
            numberUnknown
          ]
          backgroundColor: [
            window.chartColors.green
            window.chartColors.orange
            window.chartColors.red
            window.chartColors.blue
            window.chartColors.purple
          ]
          label: 'Dataset 1'
        } ]
        labels: [
          'BF No Warranty'
          'BF Warranty'
          'Data Request'
          'Support'
          'Unknown'
        ]
      options:
        showAllTooltips: false
        responsive: true
        plugins: datalabels: color: 'black'
        legend:
          display: true
          position: 'left'
          labels:
            fontColor: 'rgb(255, 255, 255)'
            fontSize: 13
        title:
          display: true
          text: classif_title
          fontColor: '#FFFFFF'
          fontSize: 15
        animation:
          animateScale: true
          animateRotate: true

    # Display chart only for configured project
    if projectFound
      myChart = new Chart(ctx, config);
      myChart.update();
    else
      console.log("Project is not into the Configuration file - Chart classif current cannot be displayed")  
      window.open("../../public/404.html","_self");
