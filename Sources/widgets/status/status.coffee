# In red "the_service" is the name of the methode(getter) used if the HTML file to call the methode
# In blue "service" is the variable returned by the getter'
#@get('service') is used to recieved the send_evend from the rb job

class Dashing.Status extends Dashing.Widget

	ready: ->
    # Get all variable 
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart Status")
      return
    projectFound =  false

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        numberPending    = projectline.chartStatus.numberPending
        numberInProgress = projectline.chartStatus.numberInProgress
        numberAssigned   = projectline.chartStatus.numberAssigned
        break
 
    # Get HTML tag
    ctx = $("#chart-status-area")[0].getContext('2d')
    
    config = 
      type: 'doughnut'
      data:
        datasets: [ {
          data: [
            numberPending #@get('pending')
            numberInProgress #@get('in_progress')
            numberAssigned #@get('assigned')
          ]
          backgroundColor: [
            window.chartColors.green
            window.chartColors.orange
            window.chartColors.red
          ]
          label: 'Dataset 1'
        } ]
        labels: [
          'Pending'
          'In Progress'
          'Assigned'
        ]
      options:
        plugins: datalabels: color: 'black'
        responsive: true
        legend:
          display: true
          labels:
            fontColor: 'rgb(255, 255, 255)'
            fontSize: 13
        title:
          display: true
          text: 'Backlog Status'
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
      console.log("Project is not into the Configuration file - Chart status cannot be displayed")
      window.open("../../public/404.html","_self");