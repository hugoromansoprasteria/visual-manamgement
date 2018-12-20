require 'tiny_tds'
require 'yaml'
require 'json'


config_gantt = File.dirname(File.expand_path(__FILE__)) + '/../../config_projects.yml'
refresh_gantt = YAML::load(File.open(config_gantt))
refresh = refresh_gantt["refresh"]                                                                                                                                                                                                                                                                                                                                                                                                                                                            


SCHEDULER.every refresh, :first_in => 0 do

    client_gantt = TinyTds::Client.new username: 'Db_Reader', password: 'MILESTONE',
        host: 'SWINAEROMPKPI01.colo.fr.sopra', port: 56649 , database: 'AEROMPSIG-KPI'

    if client_gantt.active? == true then puts 'sqlserver.rb: Connection Done to AEROMPSIG-KPI' end

    def execute(sql)
        result = client_gantt.execute(sql)
        result.each
        if result.affected_rows > 0 then puts "#{result.affected_rows} row(s) affected" end
    end

    config = YAML::load(File.open(config_gantt))

    unless config["gantt"].nil?
        config["gantt"].each do |gantt|

            puts gantt

            gantt_id = gantt["gantt_id"]
            bundle = gantt["bundle"]
            project = gantt["project"]            
            date_start = gantt["date_start"]
            date_progress = gantt["date_progress"]
            date_end = gantt["date_end"]
            
            sentence = ""
            today = Date.today

            if project == "('ALL')"
                sentence= "PID_Bundle = #{bundle}"
            else
                sentence= "PID_Project_Name IN #{project} AND PID_Bundle = #{bundle}"
            end
        
            events = []
            #gantt_list = { "gantt": []}
            gantt_list = JSON.parse('{ "gantt":[]}')

            client_gantt.execute("SELECT
            CONVERT(VARCHAR(23),MIL_#{date_end},120) AS END_C, 
            CONVERT(VARCHAR(23),MIL_#{date_start},120) AS START_C, 
            CONVERT(VARCHAR(23),MIL_#{date_progress},120) AS PROGRESS_C, 
            MIL_CHANGE, MIL_PROGRAM, PID_Project_Name, PID_Bundle, MIL_Base_Plan
            FROM dbo.MP_PROJECTS_MILESTONE
            WHERE #{sentence} AND MIL_#{date_end} > '#{today}' AND MIL_Base_Plan = 'P'
            ORDER BY MIL_#{date_end} asc").each do |row|
            
                events << { end: row["END_C"], start:row["START_C"] , progress:row["PROGRESS_C"],  name:row["MIL_CHANGE"], program:row["MIL_PROGRAM"], project: row["PID_Project_Name"], bundle:row["PID_Bundle"] }
                gantt_list["gantt"].push({ "end" => row["END_C"], "start" => row["START_C"] , "progress" => row["PROGRESS_C"],  "name" => row["MIL_CHANGE"], 
                    "program" => row["MIL_PROGRAM"], "project" => row["PID_Project_Name"], "bundle" => row["PID_Bundle"] })
                
            end

            #puts "sqlserver.rb: selection result:"
            puts ActiveSupport::JSON.encode(gantt_list)
            
            send_event(gantt_id, {mydata: events, project_title: project, bundle_title: bundle})

        end
    end  
    client_gantt.close
end