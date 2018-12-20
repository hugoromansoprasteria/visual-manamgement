# In red "the_service" is the name of the methode(getter) used if the HTML file to call the methode
# In blue "service" is the variable returned by the getter'
#@get('service') is used to recieved the send_evend from the rb job

class Dashing.Text_resolved extends Dashing.Widget

	ready: ->
    projectListJson = @get('projects_json')
    try
      projectListData = JSON.parse(projectListJson)
    catch
      console.log("Json is not defined into TextChart")
      return

    projectUrl = Tool.getURLParams().project
        
    for projectline in projectListData["projectList"]
      if projectline.url_id == projectUrl
        title = "Tickets closed for  " + projectline.title
        ctx = $("#service-name-resolved")[0].append(title)
