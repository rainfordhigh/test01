<#
SnG super script Jan 2024

Connect science sharepoint library
V4 - check user group 'SP Photography' (non AD module) NOT WORKING
#>

$username = (whoami).split('\')[1]
#$user = Get-ADGroupMember -Identity 'sp photography' -Recursive | Where-Object {$_.SamAccountName -eq $username}
#$user = (get-aduser $env:USERNAME -Properties memberof | select -expand memberof | get-adgroup) | select Name | Where-Object {$_.Name -eq 'sp photography'}
$user = whoami /groups /fo CSV | ConvertFrom-Csv |where-object {$_."Group Name" -eq 'RHS\sp staff science'}

 if($user){

$userEmail = $(whoami /upn | Out-String).Trim()
$siteID = "{a4f7b919-5944-42ac-82c0-d90b3c455e5d}"
$tenantName = "Rainford High School"
$webID = "{f216939d-1ddc-40a6-89ff-682ab3b29f60}"
$webTitle = "Science"
$webUrl = "https://rainfordhighschool.sharepoint.com/sites/FileLibraries"
$listId = "b2a089f5-30a7-45d7-8f21-1867664ae213"
$listTitle = "Staff"

#Wait for OD updates to complete
While(Get-Process *OneDrive*Update*){

    Start-Sleep 2
    #Need an exit to this if looped for tooo long
}
Start-Sleep 2
#end wait

#Wait for OD to be running
$ProcessActive = Get-Process OneDrive -ErrorAction SilentlyContinue
while($processactive.count -eq 0)
{
    Start-Sleep 2
    $ProcessActive = Get-Process OneDrive -ErrorAction SilentlyContinu
    #Need an exit to this
}
Start-Sleep 2
#end wait


if (-not ((Test-Path -Path "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1\Tenants\$tenantName") -and (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1\Tenants\$tenantName" -Name "$env:USERPROFILE\$tenantName\$webTitle - $listTitle"))) {
    $URL = "odopen://sync/?userEmail=" + $userEmail + "&siteId=" + $siteID + "&webId=" + $webID + "&webTitle="+ $webTitle + "&webUrl="+ $webUrl + "&listId="+ $listId + "&listTitle="+ $listTitle
    Start-Process "$env:ProgramFiles\Microsoft OneDrive\OneDrive.exe" -ArgumentList "/url:$URL"
}
}
