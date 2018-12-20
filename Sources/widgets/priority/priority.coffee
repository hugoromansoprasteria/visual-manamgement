# In red "the_service" is the name of the methode(getter) used if the HTML file to call the methode
# In blue "service" is the variable returned by the getter'
#@get('service') is used to recieved the send_evend from the rb job

class Dashing.Priority extends Dashing.Widget 

	ready: ->
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart Priority")
      return
    projectFound =  false
    
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        numberLow    = projectline.chartPriority.numberLow
        numberMedium = projectline.chartPriority.numberMedium
        numberHigh   = projectline.chartPriority.numberHigh
        break

    ctx = $("#chart-priority-area")[0].getContext('2d')

    config = 
          type: 'doughnut'
          data:
            datasets: [ {
              data: [
                 numberHigh #@get('high')
                 numberMedium #@get('medium')
                 numberLow #@get('low')
              ]
              backgroundColor: [
                window.chartColors.red
                window.chartColors.orange
                window.chartColors.green
              ]
              label: 'Dataset 1'
            } ]
            labels: [
              'High'
              'Medium'
              'Low'
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
              text: 'Backlog Priority'
              fontColor: '#FFFFFF'
              fontSize: 15
            animation:
              animateScale: true
              animateRotate: true

    if projectFound
      myChart = new Chart(ctx, config);
      myChart.update();
    else
      console.log("Project is not into the Configuration file - Chart priority cannot be displayed")
      window.open("../../public/404.html","_self");