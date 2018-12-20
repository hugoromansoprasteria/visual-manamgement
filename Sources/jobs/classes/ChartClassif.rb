
class ChartClassif
  # Constant
  BF_NO_WARRANTY = "BF NO WARRANTY"
  BF_WARRANTY    = "BF WARRANTY" 
  DATAREQUEST    = "DATA REQUEST"
  SUPPORT        = "SUPPORT"
  UNKNOWN        = "Unknown"
  
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :numberBfNoWar, :numberBfWar, :numberDataReq, :numberSupport, :numberUnknown
    
  # Constructor
  def initialize
    @numberBfNoWar = ""
    @numberBfWar = ""
    @numberDataReq = ""
    @numberSupport = ""
    @numberUnknown = ""
  end
end 
# End class