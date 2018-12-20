# In red "the_service" is the name of the methode(getter) used if the HTML file to call the methode
# In blue "service" is the variable returned by the getter'
#@get('service') is used to recieved the send_evend from the rb job

class Dashing.Classif extends Dashing.Widget
  ready: ->
    projectUrl = Tool.getURLParams().project
    projectListJson = @get('projects_json')

    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into Chart Classif")
      return

    projectFound =  false

    # Project filter
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        projectFound =  true
        classif_bf_nw        = projectline.chartClassif.numberBfNoWar
        classif_bf_w         = projectline.chartClassif.numberBfWar
        classif_data_request = projectline.chartClassif.numberDataReq
        classif_support      = projectline.chartClassif.numberSupport
        classif_unknown      = projectline.chartClassif.numberUnknown
        break

    # Get HTML tag
    ctx = $("#chart-classif-area")[0].getContext('2d')

    config =
          type: 'doughnut'
          data:
            datasets: [ {
              data: [
                classif_bf_nw
                classif_bf_w
                classif_data_request
                classif_support
                classif_unknown
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
            plugins: datalabels: color: 'black'
            responsive: true
            legend:
              display: true
              labels:
                fontColor: 'rgb(255, 255, 255)'
                fontSize: 13
            title:
              display: true
              text: 'Backlog Classification'
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
      console.log("Project is not into the Configuration file - Chart classif cannot be displayed")
      window.open("../../public/404.html","_self");