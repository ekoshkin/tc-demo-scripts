#
# ConvertNet40ReqScript.ps1
#

#Clear-Host

Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "\modules\bootstrap.psm1") -Force -DisableNameChecking

Get-Location

$userGroupName = "ALL_USERS_GROUP"

$password = convertto-securestring "123" -asplaintext -force
$connection = @{
		 ServerUrl = "localhost:8111"
		 Credential = new-object -typename System.Management.Automation.PSCredential ` -argumentlist "admin", $password
	 }

$client = New-TeamCityConnection -ConnectionDetails $connection

Set-Location -Path "..\static-resources-repo\"

Write-Host "Listing all users in a group" $userGroupName
foreach($user in $client.Users.AllUsersByUserGroup($userGroupName)){
    $userDetails = $client.Users.Details($user.Username)
    Write-Host "Found user" $userDetails.Username "with e-mail " $userDetails.Email
    $author = “{0} <{1}>” -f $userDetails.Username, $userDetails.Email
    Write-Host "Will generate commit on-behalf of $author" 
    Generate-Git-Commit-With-File-Change -Author $author -Branch "master" -FilePath "readme.txt"
}