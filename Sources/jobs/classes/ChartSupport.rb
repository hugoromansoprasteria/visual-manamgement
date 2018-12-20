
class ChartSupport
  #Constant
  BATCH_SCHEDULING_ISSUE = "BATCH SCHEDULING ISSUE"
  ISSUE_ON_NON_IC_APP    = "ISSUE DUE TO AN APPLI OR TO DATA NON IC"
  ISSUE_WRONG_OP_BATCH   = "ISSUE DUE TO A WRONG OPERATION ON BATCH OR INFRA"
  ISSUE_ON_IC_APP        = "ISSUE DUE TO ANOTHER IC APPLI"
  PROG_VER_CONF_ERROR    = "PROGRAM VERSION CONFIGURATION MGT ERROR"
  ROOT_CAUSE_UNKNOWN     = "ROOT CAUSE UNKNOWN"
  SPEC_DOES_NOT_FIT_BR   = "SPECIFICATION DOES NOT FIT BUSINESS REQUIREMENT"
  USER_HOW_DO_I          = "USER - HOW DO I"
  USER_WRONG_APP_USAGE   = "USER - WRONG APPLI USAGE"  
 
  # Attributs + Getter and Setter thanks to "attr_accessor" 
  attr_accessor :numberBatchScheIssue, :numberIssueNonIC, :numberIssueIC, 
                :numberIssueWrongOp, :numberProgVerConf, :numberRootCauseUnknown, 
                :numberSpecNotFit, :numberHowDoI, :numberWrongUsage  

  # Constructor
  def initialize
    @numberBatchScheIssue = ""
    @numberIssueNonIC = ""
    @numberIssueIC = ""
    @numberIssueWrongOp = ""
    @numberProgVerConf = ""
    @numberRootCauseUnknown = ""
    @numberSpecNotFit = ""
    @numberHowDoI = ""
    @numberWrongUsage = ""
  end
end 
# End class