
class ChartBarOpen 
  
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :numberOpenClosed, :numberOpen, :numberResolved, :numberResolvedKo

  # Constructor
  def initialize
    @numberOpenClosed = []
    @numberOpen       = []
    @numberResolved   = []
    @numberResolvedKo = []
  end
  
end 
# End class