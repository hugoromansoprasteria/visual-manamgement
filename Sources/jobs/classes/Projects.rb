require_relative 'Project'
class Projects

# Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :projectList 

  # Constructor
  def initialize
      @projectList = []
  end  
  
  def loadProjectList(configFile)
    # For each project into config file create a New Project
    unless configFile["as"].nil?
      configFile["as"].each do |project|
        new_proj = Project.new
        new_proj.title = project["title"]
        new_proj.url_id = project["url_id"]
        new_proj.service_id = project["service_id"]
        new_proj.resolver_grp = project["resolver_grp"]

        new_proj.sqlHelper.setRequests(new_proj.service_id,new_proj.resolver_grp)
        
        @projectList << new_proj
      end
    end
  end 

  # Return the reference of the Project ( Can me modified by the caller )
  def getProject(url_id)
    for project in @projectList do
      if project.url_id == url_id
        return project
      end
    end
  end

end 
# End class