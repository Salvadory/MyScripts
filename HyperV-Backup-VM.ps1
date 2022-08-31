$Logfile = "E:\Hyper-V\Log.log"
Function LogWrite
{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}


LogWrite "Start Script [$([DateTime]::Now)]" 
Start-Transcript -path E:\Hyper-V\Log.log -append 
# Проверка состояния VM
Get-VM #| Out-File proc.txt -Append

# Выполняем настройку дней хранения данных.
$TargetFolder = "E:\Hyper-V\VMBackup" # Путь к папке.
$Period = "-2" # Количество хранимых дней. число отрицательное

# Вычисляем дату после которой будем удалять файлы.
$CurrentDay = Get-Date
$ChDaysDel = $CurrentDay.AddDays($Period)
# Удаление файлов, дата создания которых больше заданного количества дней
GCI -Path $TargetFolder -Recurse | Where-Object {$_.CreationTime -LT $ChDaysDel} | RI -Recurse -Force 
# Удаление пустых папок
GCI -Path $TargetFolder -Recurse | Where-Object {$_.PSIsContainer -and @(Get-ChildItem -Path $_.Fullname -Recurse | Where { -not $_.PSIsContainer }).Count -eq 0 } | RI -Recurse

# Создаем папку с текущей датой
$dirname = "$((Get-Date).ToString('dd-MM-yyyy'))"
$fpath = "E:\Hyper-V\VMBackup\$dirname" 
$isfile = Test-Path $fpath 
if($isfile -eq "True") {
  # LogWrite "File found and will be not create" 
}
else {
   #LogWrite "File not found and will be create" 
   New-Item -ItemType Directory -Path E:\Hyper-V\VMBackup\$dirname
} 
Stop-Transcript
start-sleep -seconds 3

# Выполняем экспорт
LogWrite "*************************************************" 
LogWrite "*************************************************"
LogWrite "*************************************************" 
LogWrite "Stop-VM  RUOMSRPA01  [$([DateTime]::Now)]" 
Stop-VM -Name RUOMSRPA01 
start-sleep -seconds 20
LogWrite "Export-VM RUOMSRPA01  [$([DateTime]::Now)]" 
Export-VM -Name RUOMSRPA01 -Path E:\Hyper-V\VMBackup\$dirname
LogWrite "Start-VM  RUOMSRPA01  [$([DateTime]::Now)]" 
Start-VM -Name RUOMSRPA01
LogWrite "Done  RUOMSRPA01  [$([DateTime]::Now)]" 
LogWrite "*************************************************" 
LogWrite "*************************************************"
LogWrite "*************************************************" 
LogWrite "Stop-VM  RUOMSRPA02  [$([DateTime]::Now)]" 
Stop-VM -Name RUOMSRPA02
start-sleep -seconds 20
LogWrite "Export-VM RUOMSRPA02  [$([DateTime]::Now)]" 
Export-VM -Name RUOMSRPA02 -Path E:\Hyper-V\VMBackup\$dirname
LogWrite "Start-VM  RUOMSRPA02  [$([DateTime]::Now)]" 
Start-VM -Name RUOMSRPA02
LogWrite "Done  RUOMSRPA02  [$([DateTime]::Now)]" 
LogWrite "*************************************************" 
LogWrite "*************************************************"
LogWrite "*************************************************" 
LogWrite "Stop-VM  RUOMSRPA03  [$([DateTime]::Now)]" 
Stop-VM -Name RUOMSRPA03
start-sleep -seconds 20
LogWrite "Export-VM RUOMSRPA03  [$([DateTime]::Now)]" 
Export-VM -Name RUOMSRPA03 -Path E:\Hyper-V\VMBackup\$dirname
LogWrite "Start-VM  RUOMSRPA03  [$([DateTime]::Now)]" 
Start-VM -Name RUOMSRPA03 
LogWrite "Done  RUOMSRPA03  [$([DateTime]::Now)]" 
LogWrite "*************************************************" 
LogWrite "*************************************************"
LogWrite "*************************************************" 
LogWrite "Stop-VM  RUOMSAPPS  [$([DateTime]::Now)]" 
Stop-VM -Name RUOMSAPPS
start-sleep -seconds 20
LogWrite "Export-VM RUOMSAPPS  [$([DateTime]::Now)]" 
Export-VM -Name RUOMSAPPS -Path E:\Hyper-V\VMBackup\$dirname
LogWrite "Start-VM  RUOMSAPPS  [$([DateTime]::Now)]" 
Start-VM -Name RUOMSAPPS 
LogWrite "Done  RUOMSAPPS  [$([DateTime]::Now)]" 
LogWrite "*************************************************" 
LogWrite "*************************************************"
LogWrite "*************************************************" 
LogWrite "Thank you, Bye Bye [$([DateTime]::Now)]" 
