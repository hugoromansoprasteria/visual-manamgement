
class ChartPriority

  #Constant
  LOW    = "Low"
  MEDIUM = "Medium"
  HIGH   = "High"  

  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :numberLow, :numberMedium, :numberHigh 
   
  # Constructor
  def initialize
    @numberLow = ""
    @numberMedium = ""
    @numberHigh = ""
  end
end 
# End class