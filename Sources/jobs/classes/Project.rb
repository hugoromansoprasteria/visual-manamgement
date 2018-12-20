require_relative 'ChartPriority'
require_relative 'ChartStatus'
require_relative 'ChartClassif'
require_relative 'ChartBarOpen'
require_relative 'ChartSupport'
require_relative 'SqlHelper'

class Project  
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :url_id, :title, :service_id, :resolver_grp,
                :chartPriority, :chartStatus, :chartClassif, 
                :chartBarOpen, 
                :chartSupportCurrentMonth, :chartSupportPrevMonth, :chartSupportTotal,     
                :chartClassifCurrentMonth, :chartClassifPrevMonth, :chartClassifTotal,
                :sqlHelper
  
  # Constructor
  def initialize  
    @title = ""
    @url_id = ""
    @service_id = ""
    @resolver_grp = ""

    @chartPriority = ChartPriority.new
    @chartStatus   = ChartStatus.new
    @chartClassif  = ChartClassif.new
    @chartBarOpen  = [] # ChartBarOpen.new

    @chartSupportCurrentMonth = ChartSupport.new
    @chartSupportPrevMonth    = ChartSupport.new  
    @chartSupportTotal        = ChartSupport.new  

    @chartClassifCurrentMonth = ChartClassif.new
    @chartClassifPrevMonth    = ChartClassif.new
    @chartClassifTotal        = ChartClassif.new

    @sqlHelper = SqlHelper.new
  end  

  # Add a new Bar chart for the project(all month and all value)
  def addNewBarChart(numberOpenClosed, numberOpen, numberResolved, numberResolvedKo)

    chartBar = ChartBarOpen.new

    chartBar.numberOpenClosed = numberOpenClosed
    chartBar.numberOpen       = numberOpen
    chartBar.numberResolved   = numberResolved
    chartBar.numberResolvedKo = numberResolvedKo

    @chartBarOpen << chartBar

  end

end 
# End class