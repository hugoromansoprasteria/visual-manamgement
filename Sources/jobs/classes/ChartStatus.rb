
class ChartStatus 

  #Constant
  IN_PROGRESS = "In Progress"
  PENDING     = "Pending"
  ASSIGNED    = "Assigned"
  
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :numberInProgress, :numberAssigned, :numberPending 
  
  # Constructor
  def initialize
    @numberInProgress = ""
    @numberAssigned = ""
    @numberPending = ""
  end
end 
# End class