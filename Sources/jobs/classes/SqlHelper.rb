class SqlHelper
 
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :serviceRequest, :resolverGrpRequest

  # Constructor
  def initialize
    @resolverGrpRequest = " "
    @serviceRequest = " "
  end

  #Static method
  def self.openConnection
    # Init the client DB connextion
     clientSql = TinyTds::Client.new username: 'AS_Reader', password: 'Toulouse31$',
      host: 'SWINNCSSTELIA01.colo.fr.sopra', port: 1433 , database: 'AS_SIG' 
      return clientSql
  end

  # Create the request variable
  def setRequests(service_id,resolver_grp)
    # if service is empty FULL (no filter), else create the request
    if service_id.nil?
      @serviceRequest = " "
    else
      @serviceRequest = "AND EadsCiBusinessService IN #{service_id}"
    end

    # if Resolver Grp is empty FULL (no filter), else create the request
    if resolver_grp.nil?
      @resolverGrpRequest = " "
    else
      @resolverGrpRequest = "AND inc.AssignedGroup IN #{resolver_grp}"
    end
  end

  def selectPriorityChart(clientSql)
    incident_prio_backlog_tab = []

    clientSql.execute("SELECT Priority, COUNT(Priority) AS Cnt_Priority
    FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
    WHERE Status IN ('Pending','Assigned','In Progress') 
    #{@resolverGrpRequest} 
    #{@serviceRequest}
    GROUP BY Priority ;").each do |row|  
      incident_prio_backlog_tab << [row["Priority"],row["Cnt_Priority"]]  
    end

    return incident_prio_backlog_tab
  end

  def selectStatusChart(clientSql)
    incident_status_backlog_tab = []

    clientSql.execute("SELECT Status, COUNT(Status) AS Cnt_Status
    FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
    WHERE Status IN ('Pending','Assigned','In Progress')
    #{@resolverGrpRequest} 
    #{@serviceRequest}
    GROUP BY Status ;").each do |row|  
      incident_status_backlog_tab << [row["Status"],row["Cnt_Status"]]  
    end  

    return incident_status_backlog_tab
  end

  def selectClassifBacklogChart(clientSql)
    incident_classif_backlog_tab = []

    clientSql.execute("SELECT ResolutionCategoryTier2, COUNT(ResolutionCategoryTier2) AS Cnt_Classif
    FROM [AS_SIG].[dwh].[SemaphoreIncidents] inc
    WHERE Status IN ('Pending','Assigned','In Progress') 
    #{@resolverGrpRequest} 
    #{@serviceRequest}
    GROUP BY ResolutionCategoryTier2").each do |row|
    
      incident_classif_backlog_tab << [row["ResolutionCategoryTier2"], row["Cnt_Classif"]]  
    end

    return incident_classif_backlog_tab
  end

  def selectBarChart(clientSql)

  end

  def selectClassifResolvedChart(clientSql)

  end

  def selectSupportResolvedChart(clientSql)

  end

end 
# End class