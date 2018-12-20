class Dashing.Support_Total extends Dashing.Widget

  ready: ->
    # Get all variable 
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart Support total")
      return
    projectFound =  false

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        
        numberBatchScheIssue   = projectline.chartSupportTotal.numberBatchScheIssue
        numberIssueNonIC       = projectline.chartSupportTotal.numberIssueNonIC
        numberIssueIC          = projectline.chartSupportTotal.numberIssueIC
        numberIssueWrongOp     = projectline.chartSupportTotal.numberIssueWrongOp
        numberProgVerConf      = projectline.chartSupportTotal.numberProgVerConf
        numberRootCauseUnknown = projectline.chartSupportTotal.numberRootCauseUnknown
        numberSpecNotFit       = projectline.chartSupportTotal.numberSpecNotFit
        numberHowDoI           = projectline.chartSupportTotal.numberHowDoI
        numberWrongUsage       = projectline.chartSupportTotal.numberWrongUsage
        break

    # Get HTML tag
    ctx = $("#chart-support-total-area")[0].getContext('2d')
    config = 
      type: 'doughnut'
      data:
        datasets: [ {
          data: [
            numberBatchScheIssue
            numberIssueNonIC
            numberIssueIC
            numberIssueWrongOp
            numberProgVerConf
            numberRootCauseUnknown
            numberSpecNotFit
            numberHowDoI
            numberWrongUsage
          ]
          backgroundColor: [
            window.chartColors.green
            window.chartColors.orange
            window.chartColors.red
            window.chartColors.blue
            window.chartColors.purple
            window.chartColors.yellow
            window.chartColors.grey
            window.chartColors.pink
            window.chartColors.cyan
          ]
          label: 'Dataset 1'
        } ]
        labels: [
          'Batch Scheduling'
          'Issue -> batch/infra'
          'Issue -> app/data N-IC'
          'Issue -> other app'
          'Program config. MGT'
          'Root cause unknown'
          'Spec. doesnt fit B-R'
          'User How Do I'
          'User Wrong App Use'
        ]
      options:
        plugins: datalabels: color: 'black'
        responsive: true
        legend:
          display: true
          position: 'right'
          labels:
            fontColor: 'rgb(255, 255, 255)'
            boxWidth: 10
            fontSize: 13
        title:
          display: true
          text: 'Focus Support in total'
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
      console.log("Project is not into the Configuration file - Chart Support Total cannot be displayed")
      window.open("../../public/404.html","_self");