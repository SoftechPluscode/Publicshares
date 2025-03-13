# dhiraj
$CurrentDate = Get-Date
$SetDate = Get-Date -Year 2025 -Month 6 -Day 1
$psfiles = Get-item ".\UserList.csv", ".\removeadminv04.ps1" -ErrorAction Ignore
$fileout = "$env:computername" + "_" + (Get-Date -Format "ddMMMyyyyhhmm") + ".log"
$outfile = ".\Status" + "_" + (Get-Date -Format "ddMMMyyyy") + ".csv"
$delfile = ".\UserList.csv"
$Error.Clear()
if (($psfiles).count -ne 0 ) {
    Write-Host "The file exists. Details:"
    $i = 0
    $UsersData = Import-Csv -Path $delfile | Where-Object { $_.Computer -eq $env:computername } | Select-Object computer, Username, Status
foreach ($usr in $UsersData) {
    try {
        if ($CurrentDate -le $SetDate ) {
            Write-Host "Processing User: $($usr.Username)"
            Remove-LocalGroupMember -Group "Administrators" -Member $usr.Username -ErrorAction SilentlyContinue
            Disable-LocalUser -Name $usr.Username -ErrorAction SilentlyContinue
            $i++
            $stu = Get-LocalUser $usr.Username -ErrorAction SilentlyContinue
            $usr.Status = if ($stu) { $stu.Enabled } else { "Not Found" }
            
        }
    }
    catch {
        Write-Host "Error processing user $($usr.Username): $_"
        $_ | Out-File -FilePath $fileout -Append
    }
}

if ($Error) {
    $Error | Out-File -FilePath $fileout -Append
}
$UsersData | Export-Csv -NoTypeInformation -Path $outfile
Write-Host "Summary of activity:"
Write-Host "1. $i Account(s)."
Write-Host "2. Status saved in file: $outfile"
$psfiles | Remove-Item
}