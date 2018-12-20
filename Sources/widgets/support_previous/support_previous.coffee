# In red "the_service" is the name of the methode(getter) used if the HTML file to call the methode
# In blue "service" is the variable returned by the getter'
#@get('service') is used to recieved the send_evend from the rb job

class Dashing.Support_Previous extends Dashing.Widget

  ready: ->
    # Get all variable 
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart Support previous")
      return
    projectFound =  false

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        
        numberBatchScheIssue   = projectline.chartSupportPrevMonth.numberBatchScheIssue
        numberIssueNonIC       = projectline.chartSupportPrevMonth.numberIssueNonIC
        numberIssueIC          = projectline.chartSupportPrevMonth.numberIssueIC
        numberIssueWrongOp     = projectline.chartSupportPrevMonth.numberIssueWrongOp
        numberProgVerConf      = projectline.chartSupportPrevMonth.numberProgVerConf
        numberRootCauseUnknown = projectline.chartSupportPrevMonth.numberRootCauseUnknown
        numberSpecNotFit       = projectline.chartSupportPrevMonth.numberSpecNotFit
        numberHowDoI           = projectline.chartSupportPrevMonth.numberHowDoI
        numberWrongUsage       = projectline.chartSupportPrevMonth.numberWrongUsage
        break

    # Determine the previous month
    supp_title = 'Focus Support for '	+ Tool.getMonthName((new Date).getMonth() - 1)

    # Get HTML tag
    ctx = $("#chart-support-previous-area")[0].getContext('2d')
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
          text: supp_title
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
      console.log("Project is not into the Configuration file - Chart Support previous cannot be displayed")
      window.open("../../public/404.html","_self");
