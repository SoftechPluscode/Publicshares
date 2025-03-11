# ssh activate and login via kay or password less 
#Connect the vCenter
$vCenter = "fihel02lvc004.nsn-hclsmd.com"
#$vHost = "fihel02esx105.nsn-hclsmd.com"
$user = 'root'
$Password = 'Abk8vmc@34it'
#$VMHosts = $outfiles | select Sno,Hostname
$i=0
#$pswdSec = ConvertTo-SecureString -String $Password -AsPlainText -Force
#Connect-VIServer  $vCenter  -User "dchopra@NSN-HCLSMD" -password "Titoo11776@1701tech1"
$VMHosts = @(Get-VMHost)
Foreach ($vHost in $VMHosts){
$sht =  "$user@$vhost :/etc/ssh/keys-root/authorized_keys"
Get-VMHost $vHost | Foreach { Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} ) }
echo y | pscp -pw $Password "C:\Users\dhchopra\.ssh\id_rsa.pub" $sht 
$i++

}
