' Script to launch Smashing Visual Managment
' Created by Hugo Roman Sopra Steria

'Set objFSO=CreateObject("Scripting.FileSystemObject")

' set the log file
objFileLog="smashing_start.log"
' Set batch file for starting Smashing server
objFileScript="smashing_start.bat"
' Set batch object
Dim WshShell

' Delete Log file if exist
Set Fso= WScript.CreateObject("Scripting.FileSystemObject" ) 
If Fso.FileExists(objFileLog) Then 
  ' Delete the file
  Set objFile = Fso.GetFile(objFileLog)  
  objFile.Delete 
End If 

' Create log file again
Set objFile = Fso.createtextFile(objFileLog,True )  

' First log
objFile.Write "Script start.vbs started!" & " Date: " & now() & vbCrLf


Set WshShell = WScript.CreateObject("WScript.Shell" )

objFile.Write "Batch smashing_start.bat will be executed soon... " & " Date: " & now() & vbCrLf
objFile.Close

WshShell.Run objFileScript, 0
WScript.Quit 0

