require 'tiny_tds'
require 'yaml'
require 'logger'
require 'json'
require 'active_support'
require_relative 'classes/Project'
require_relative 'classes/Projects'
require_relative 'classes/LoggerAs'

# Prepare data/time variables
time           = Time.new          
this_month     = time.month
this_year      = time.year
previous_month = time.month - 1
next_month     = time.month + 1

if this_month == 12
  next_month = 1
end

if this_month == 1
  previous_month = 12
end

# Get the config file
new_config_as = File.dirname(File.expand_path(__FILE__)) + '/../../config_projects.yml'
new_config    = YAML::load(File.open(new_config_as))

new_config_refresh    = YAML::load(File.open(new_config_as))
refresh = new_config_refresh["refresh"]
new_config_refresh = ""

# Create an instance of Projects, used to store all the Project from Config file and all data frome the SQL DB
projects = Projects.new
projects.loadProjectList(new_config)

SCHEDULER.every refresh, :first_in => 0 do

  # Create Log object
  logger = LoggerAs.new()
  logger.add_log("Job Started")
  logger.add_log("Connecting to SQL Server...")

  # Init the client DB connextion
  clientSql = SqlHelper.openConnection

  # Check if active
  if clientSql.active? == true then 
    logger.add_log("Connection done to AS_SIG")
  else
    logger.add_log_error("Connection failed to AS_SIG")
  end  

  # Loop over all project (from config file)
  projects.projectList.each do |project|
      
###########################################################################################################
################################  WIDGET CLASSIFICATION RESOLVED ########################################## 
###########################################################################################################

    for i in 0..2
      date = "" 
      if i == 0
        date = " AND (IncidentLastResolvedDate >= '#{this_year}-#{this_month}-01' AND IncidentLastResolvedDate < '#{this_year}-#{next_month}-01')" 
      end  
      if i == 1
        date = " AND (IncidentLastResolvedDate >= '#{this_year}-#{previous_month}-01' AND IncidentLastResolvedDate < '#{this_year}-#{this_month}-01')"
      end  

      incident_classif_resolved_tab = []  

      clientSql.execute("SELECT ResolutionCategoryTier2 ,COUNT (ResolutionCategoryTier2) as Cnt_Classif
      FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
      WHERE Status IN ('Closed', 'Resolved') 
      #{project.sqlHelper.resolverGrpRequest} 
      #{project.sqlHelper.serviceRequest} 
      #{date}
      GROUP BY ResolutionCategoryTier2").each do |row|
 
        incident_classif_resolved_tab << [row["ResolutionCategoryTier2"], row["Cnt_Classif"]]
      end     
      
      #Inisialization is very important, javascript will no triggered if not
      the_bfwn = " "
      the_bfw = " "
      the_dr = " "
      the_support = " "
      the_unknown = " "  

      for incident_classif_resolved_line in incident_classif_resolved_tab
        case incident_classif_resolved_line[0]
        when "BF NO WARRANTY"
          the_bfwn = incident_classif_resolved_line[1]
        when "BF WARRANTY"
          the_bfw = incident_classif_resolved_line[1]
        when "DATA REQUEST"
          the_dr = incident_classif_resolved_line[1]
        when "SUPPORT"
          the_support = incident_classif_resolved_line[1]
        when "Unknown"
          the_unknown = incident_classif_resolved_line[1]
        end
      end 

      #Fill the Projects object
      case i
      when 0
        project.chartClassifCurrentMonth.numberBfNoWar = the_bfwn
        project.chartClassifCurrentMonth.numberBfWar   = the_bfw
        project.chartClassifCurrentMonth.numberDataReq = the_dr
        project.chartClassifCurrentMonth.numberSupport = the_support
        project.chartClassifCurrentMonth.numberUnknown = the_unknown 
      when 1
        project.chartClassifPrevMonth.numberBfNoWar = the_bfwn
        project.chartClassifPrevMonth.numberBfWar   = the_bfw
        project.chartClassifPrevMonth.numberDataReq = the_dr
        project.chartClassifPrevMonth.numberSupport = the_support
        project.chartClassifPrevMonth.numberUnknown = the_unknown 
      when 2
        project.chartClassifTotal.numberBfNoWar = the_bfwn
        project.chartClassifTotal.numberBfWar   = the_bfw
        project.chartClassifTotal.numberDataReq = the_dr
        project.chartClassifTotal.numberSupport = the_support
        project.chartClassifTotal.numberUnknown = the_unknown 
      end
    end  
      
###########################################################################################################
############################   WIDGETS FOCUS SUPPORT M-1, M, TOTAL ######################################## 
###########################################################################################################

    for i in 0..2
      date = "" 
      if i == 0
        date = " AND (IncidentLastResolvedDate >= '#{this_year}-#{this_month}-01' AND IncidentLastResolvedDate < '#{this_year}-#{next_month}-01')" 
      end  
      if i == 1
        date = " AND (IncidentLastResolvedDate >= '#{this_year}-#{previous_month}-01' AND IncidentLastResolvedDate < '#{this_year}-#{this_month}-01')"
      end
  
      incident_support_resolved_tab = [] 

      clientSql.execute("SELECT ResolutionCategoryTier3 ,COUNT (ResolutionCategoryTier3) as Cnt_Support
      FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
      WHERE Status IN ('Closed', 'Resolved') 
      #{project.sqlHelper.resolverGrpRequest} 
      #{project.sqlHelper.serviceRequest}
      #{date}
      AND ResolutionCategoryTier2 = 'SUPPORT' 
      GROUP BY ResolutionCategoryTier3").each do |row|  
        incident_support_resolved_tab << [row["ResolutionCategoryTier3"], row["Cnt_Support"]]  
      end     

      the_batch = " "    
      the_issue1 = " "
      the_issue2 = " "
      the_issue3 = " "
      the_program = " "
      the_root = " "
      the_root = " "
      the_spec = " "
      the_user1 = " "
      the_user2 = " " 

      for incident_support_resolved_line in incident_support_resolved_tab
        case incident_support_resolved_line[0]
        when "BATCH SCHEDULING ISSUE"
          the_batch = incident_support_resolved_line[1]
        when "ISSUE DUE TO A WRONG OPERATION ON BATCH OR INFRA"
          the_issue1 = incident_support_resolved_line[1]
        when "ISSUE DUE TO AN APPLI OR TO DATA NON IC"
          the_issue2 = incident_support_resolved_line[1]
        when "ISSUE DUE TO ANOTHER IC APPLI"
          the_issue3 = incident_support_resolved_line[1]
        when "PROGRAM VERSION CONFIGURATION MGT ERROR"
          the_program = incident_support_resolved_line[1]
        when "ROOT CAUSE UNKNOWN"
          the_root = incident_support_resolved_line[1]
        when "SPECIFICATION DOES NOT FIT BUSINESS REQUIREMENT"
          the_spec = incident_support_resolved_line[1]
        when "USER - HOW DO I"
          the_user1 = incident_support_resolved_line[1]
        when "USER - WRONG APPLI USAGE"
          the_user2 = incident_support_resolved_line[1]
        end
      end  

      incident_support_resolved_tab.clear          

      #Fill the Projects object
      case i
      when 0
        project.chartSupportCurrentMonth.numberBatchScheIssue   = the_batch
        project.chartSupportCurrentMonth.numberIssueWrongOp     = the_issue1
        project.chartSupportCurrentMonth.numberIssueNonIC       = the_issue2
        project.chartSupportCurrentMonth.numberIssueIC          = the_issue3
        project.chartSupportCurrentMonth.numberProgVerConf      = the_program
        project.chartSupportCurrentMonth.numberRootCauseUnknown = the_root 
        project.chartSupportCurrentMonth.numberSpecNotFit       = the_spec 
        project.chartSupportCurrentMonth.numberHowDoI           = the_user1 
        project.chartSupportCurrentMonth.numberWrongUsage       = the_user2 
      when 1
        project.chartSupportPrevMonth.numberBatchScheIssue   = the_batch
        project.chartSupportPrevMonth.numberIssueWrongOp     = the_issue1
        project.chartSupportPrevMonth.numberIssueNonIC       = the_issue2
        project.chartSupportPrevMonth.numberIssueIC          = the_issue3
        project.chartSupportPrevMonth.numberProgVerConf      = the_program
        project.chartSupportPrevMonth.numberRootCauseUnknown = the_root 
        project.chartSupportPrevMonth.numberSpecNotFit       = the_spec 
        project.chartSupportPrevMonth.numberHowDoI           = the_user1 
        project.chartSupportPrevMonth.numberWrongUsage       = the_user2 
      when 2
        project.chartSupportTotal.numberBatchScheIssue   = the_batch
        project.chartSupportTotal.numberIssueWrongOp     = the_issue1
        project.chartSupportTotal.numberIssueNonIC       = the_issue2
        project.chartSupportTotal.numberIssueIC          = the_issue3
        project.chartSupportTotal.numberProgVerConf      = the_program
        project.chartSupportTotal.numberRootCauseUnknown = the_root 
        project.chartSupportTotal.numberSpecNotFit       = the_spec 
        project.chartSupportTotal.numberHowDoI           = the_user1 
        project.chartSupportTotal.numberWrongUsage       = the_user2 
      end
      
    end  
    
###########################################################################################################
#################################### WIDGET STATUS  ####################################################### 
###########################################################################################################

    incident_status_backlog_tab = []  
    the_in_p = " "
    the_pending = " "
    the_assigned = " "
    
    # Database selection
    incident_status_backlog_tab = project.sqlHelper.selectStatusChart(clientSql)  

    #for each line get the number of incident by Status
    for incident_status_line in incident_status_backlog_tab
      case incident_status_line[0]
      when "In Progress"
        the_in_p = incident_status_line[1]
      when "Pending"
        the_pending = incident_status_line[1]
      when "Assigned"
        the_assigned = incident_status_line[1]
      end
    end
    
    incident_status_backlog_tab.clear  

    #Fill the Project object
    project.chartStatus.numberPending    = the_pending
    project.chartStatus.numberInProgress = the_in_p
    project.chartStatus.numberAssigned   = the_assigned  
      
###########################################################################################################
###################################   WIDGET PRIORITY ##################################################### 
########################################################################################################### 

    incident_prio_backlog_tab = []
    the_low = " "
    the_medium = " "
    the_high = " "

    # Database selection
    incident_prio_backlog_tab = project.sqlHelper.selectPriorityChart(clientSql) 

    #for each line get the number of incident by priority
    for incident_prio_line in incident_prio_backlog_tab
      case incident_prio_line[0]
      when "Low"
        the_low = incident_prio_line[1]
      when "Medium"
        the_medium = incident_prio_line[1]
      when "High"
        the_high = incident_prio_line[1]
      end
    end  

    incident_prio_backlog_tab.clear  

    #Fill the Project object with value of Prioriy
    project.chartPriority.numberLow = the_low
    project.chartPriority.numberMedium = the_medium
    project.chartPriority.numberHigh = the_high  

###########################################################################################################
################################ WIDGET CLASSIFICATION BACKLOG ############################################ 
###########################################################################################################

    incident_classif_backlog_tab = [] 
    the_bfwn = " "
    the_bfw = " "
    the_dr = " "
    the_support = " "
    the_unknown = " " 

    # Database selection
    project.sqlHelper.selectClassifBacklogChart(clientSql)
    
    for incident_classif_backlog_line in incident_classif_backlog_tab
      case incident_classif_backlog_line[0]
      when "BF NO WARRANTY"
        the_bfwn = incident_classif_backlog_line[1]
      when "BF WARRANTY"
        the_bfw = incident_classif_backlog_line[1]
      when "DATA REQUEST"
        the_dr = incident_classif_backlog_line[1]
      when "SUPPORT"
        the_support = incident_classif_backlog_line[1]
      when "Unknown"
        the_unknown = incident_classif_backlog_line[1]
      end
    end  

    incident_classif_backlog_tab.clear  

    #Fill the Project object
    project.chartClassif.numberBfNoWar = the_bfwn
    project.chartClassif.numberBfWar   = the_bfw
    project.chartClassif.numberDataReq = the_dr
    project.chartClassif.numberSupport = the_support
    project.chartClassif.numberUnknown = the_unknown  

      
###########################################################################################################
####################################### BAR CHART BACKLOG ################################################# 
###########################################################################################################

    the_orange = []
    the_blue = []
    the_red = []
    the_green = [] 

    for i in 1..12
      
      barChart_next_month = i + 1
      if i == 12
        barChart_next_month = 1
      end  

      incident_open_not_closed_tab = []
      incident_open_and_closed_tab = []
      incident_resolved_sla_tab = []

      clientSql.execute("SELECT Status,COUNT (Status) as Cnt_Status
      FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
      WHERE Status NOT IN ('Closed', 'Resolved') 
      #{project.sqlHelper.resolverGrpRequest} 
      #{project.sqlHelper.serviceRequest}
      AND (IncidentReportedDate >= '#{this_year}-#{i}-01')
      GROUP BY Status").each do |row|
      
        incident_open_not_closed_tab << [row["Status"], row["Cnt_Status"]]  
      end
      
      sum_for_this_month = 0
      for incident_open_not_closed_line in incident_open_not_closed_tab
        if incident_open_not_closed_line[0] == "Pending" || 
            incident_open_not_closed_line[0] == "In Progress" || 
            incident_open_not_closed_line[0] == "Assigned"  

          sum_for_this_month = sum_for_this_month + incident_open_not_closed_line[1]             
        end
      end 

      if sum_for_this_month == 0
        the_orange << " "
      else
        the_orange << sum_for_this_month.to_s
      end 

      incident_open_not_closed_tab.clear
                      
      clientSql.execute("SELECT Status , Count (status) as Cnt_Status
      FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
      WHERE Status IN ('Closed', 'Resolved') 
      #{project.sqlHelper.resolverGrpRequest} 
      #{project.sqlHelper.serviceRequest}
      AND (IncidentReportedDate >= '#{this_year}-#{i}-01' 
      AND IncidentLastResolvedDate < '#{this_year}-#{barChart_next_month}-01')
      Group By Status").each do |row|
      
        incident_open_and_closed_tab << [row["Status"], row["Cnt_Status"]]  
      end
      
      sum_for_this_month = 0
      for incident_open_and_closed_line in incident_open_and_closed_tab
        if incident_open_and_closed_line[0] == "Closed" || 
          incident_open_and_closed_line[0] == "Resolved"  
          sum_for_this_month = sum_for_this_month + incident_open_and_closed_line[1]             
        end
      end  

      if sum_for_this_month == 0
        the_blue << " "
      else
        the_blue << sum_for_this_month.to_s
      end

      incident_open_and_closed_tab.clear 

      clientSql.execute("SELECT PROGRESS, count(Progress) as Cnt_Progress
      FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
      INNER JOIN [AS_SIG].[dwh].[SlaOla] ind ON inc.IncidentId = ind.IncidentId
      WHERE Status IN ('Resolved','Closed') 
      #{project.sqlHelper.resolverGrpRequest} 
      #{project.sqlHelper.serviceRequest}
      AND (IncidentLastResolvedDate >= '#{this_year}-#{i}-01' 
      AND IncidentLastResolvedDate < '#{this_year}-#{barChart_next_month}-01')
      GROUP BY Progress").each do |row|
      
        incident_resolved_sla_tab << [row["PROGRESS"], row["Cnt_Progress"]]
      end
      
      the_green_tmp = ""
      the_red_tmp = ""

      for incident_resolved_sla_line in incident_resolved_sla_tab
        if incident_resolved_sla_line[1] != 0

          if incident_resolved_sla_line[0] == "Met"
            the_green_tmp = incident_resolved_sla_line[1].to_s
          end

          if incident_resolved_sla_line[0] == "Missed"
            the_red_tmp = incident_resolved_sla_line[1].to_s
          end
        end
      end

      if the_red_tmp != ""
        the_red << the_red_tmp
        if the_green_tmp == ""
          the_green << " "
        end
      end

      if the_green_tmp != ""
        the_green << the_green_tmp
        if the_red_tmp == ""
          the_red << " "
        end
      end

      if !incident_resolved_sla_tab.any?
        the_green << " "
        the_red << " "
      end
      
      incident_resolved_sla_tab.clear  
    end

    #Fill the Project object
    project.addNewBarChart(the_blue,the_orange,the_green,the_red)
    
  end

  #Encode object to Json format
  ProjectsJson = ActiveSupport::JSON.encode(projects)

  # AS Backlog page
  send_event('priority', {projects_json: ProjectsJson}) 
  send_event('status', {projects_json: ProjectsJson}) 
  send_event('classif', {projects_json: ProjectsJson}) 
  send_event('chart', {projects_json: ProjectsJson}) 

  # AS Resolved page
  # Classif
  send_event('classif_previous_month', {projects_json: ProjectsJson}) 
  send_event('classif_current_month', {projects_json: ProjectsJson}) 
  send_event('classif_total', {projects_json: ProjectsJson}) 

  # Support
  send_event('supp_previous_month', {projects_json: ProjectsJson}) 
  send_event('supp_current_month', {projects_json: ProjectsJson}) 
  send_event('supp_total', {projects_json: ProjectsJson}) 

  # Title for AS Backlog
  send_event('service', {projects_json: ProjectsJson})
  # Title for AS Resolved
  send_event('service_resolved', {projects_json: ProjectsJson})

  clientSql.close

  # Log time
  logger.add_log("For json reader you can use https://jsoneditoronline.org/ or other website")
  logger.add_log(ProjectsJson)
  logger.add_log("Job Ended")
  logger.close

end