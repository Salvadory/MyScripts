Do
Set WshShell = WScript.CreateObject("WScript.Shell")
Set objWMIService=GetObject("winmgmts:\\.\root\cimv2")
Set colOperatingSystems=objWMIService.ExecQuery _
  ("Select * From Win32_PerfFormattedData_PerfOS_System")
For Each objOS in colOperatingSystems
  intSystemUptime = Int(objOS.SystemUpTime) 
  s = Int(objOS.SystemUpTime)
  TimedAt=FormatDateTime(Date(),2) &", " &FormatDateTime(Time(),4)
  M=S\60 : S=S mod 60 : H=M\60 : M=M mod 60 : D=H\24
  UpTime =D &" Days, " & H MOD 24 &" Hours, " &M &" Minutes"
Next

'Если вы хотите 100 секунд , используйте 100 * 1000, так как значение равно миллисекундам. 

IF intSystemUptime <=259200 then ' до 3 дней
WScript.Sleep(60*60*12*1000)  '12 часов
elseif intSystemUptime => 259201 and intSystemUptime <= 345600 then ' 3-4 дня
WshShell.Popup "Время работы системы " & UpTime & "," & vbCrLf & "требуется перезагрузка",20,"Уведомление", 64 
WScript.Sleep(60*60*2*1000) '2 часа 
elseif intSystemUptime => 345601 and intSystemUptime <= 432000  then '4-5 дня
WshShell.Popup "Время работы системы " & UpTime & "," & vbCrLf & " требуется перезагрузка",20,"Внимание", 64
WScript.Sleep(60*30*1000) ' 30 минут
elseif intSystemUptime => 432001 then '5+ дней
  Testcheck = (60*60*1000) - check
  WshShell.Popup "Время работы системы " & UpTime & "," & vbCrLf &"Компьютер будет перезагружен через " & Testcheck/60/1000 & " минут. "& vbCrLf & "Настоятельно рекомендуем сохранить ваши файлы"  ,120,"Внимание", 16
  WScript.Sleep(60*10*1000) ' 10 минут
  check = check + (60*10*1000)
  
  if check  >= (60*60*1000) then 
	'WshShell.run "shutdown.exe"
	' ' или
	 Set OpSysSet = GetObject("winmgmts:{(Shutdown)}" ).ExecQuery("select * from Win32_OperatingSystem where Primary=true" )
	 For Each OpSys In OpSysSet
	 OpSys.Reboot()
	 Next
	end if
end if
Loop
