
class ChartGantt
  
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :programName, :projectName, :bundleName, :startDate, :endDate, :progressDate, :description

  # Constructor
  def initialize
    @programName  = ""
    @projectName  = ""
    @bundleName   = ""
    @endDate      = ""
    @startDate    = ""
    @progressDate = ""
    @description  = ""
  end
  
end 
# End class