<powershell>
Start-Transcript -Path "C:\domain_join_logs.txt" -Append
#$instanceId = (invoke-webrequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content
#$nameValue = (get-ec2tag -filter @{Name="resource-id";Value=$instanceid},@{Name="key";Value="Name"}).Value
$nameValue = "HOSTNAME"
$computername = (Get-WmiObject Win32_ComputerSystem)
try{  
     $computername.Rename($nameValue) | Out-File -FilePath "C:\ps1logs.txt" -Append
}
catch{
     $_.Exception | Out-File -FilePath "C:\ps1logs.txt" -Append
} Finally{
     Start-Sleep -s 300
     $computername.Rename($nameValue)
}  
# $computername.Rename($nameValue)  
$oldName = hostname  
$domain = "" # Add Domain Name
$password = '' | ConvertTo-SecureString -asPlainText -Force  # Add domain join service user password
$username = ""   #Add domain join service user
$credential = New-Object System.Management.Automation.PSCredential($username,$password)  
Add-Computer -DomainName $domain -ComputerName $oldName -NewName $nameValue -Credential $credential 
Stop-Transcript
Restart-Computer -Force
     yes

</powershell>