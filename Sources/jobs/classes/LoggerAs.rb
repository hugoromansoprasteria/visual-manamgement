
class LoggerAs < Logger

 
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :file  

  # Constructor
  def initialize
    # Create file Log
    @file = File.open('AS_logfile.log', File::WRONLY | File::APPEND | File::CREAT)
    # Call super constructor
    super(@file,'weekly')
  end

  def add_log(log)
    # If debug is up log
    if debugOn?
      info { log }
    end
  end

  def add_log_error(log)
    # If debug is up log
    if debugOn?
      warn { log }
    end
  end

  def debugOn?

    debugFile = File.dirname(File.expand_path(__FILE__)) + '/../../config_debug.yml'
    debugConf = YAML::load(File.open(debugFile))    

    unless debugConf["debug"].nil?
      debugConf["debug"].each do |debug|
        if debug['status'] == 'ON'
          return true
        end
      end
    end
    return false
  end

end 
# End class