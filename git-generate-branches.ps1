#
# generate-branches.ps1
#
Clear-Host
    
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..\TeamCity\TeamCity.psm1") -Force -DisableNameChecking

$userGroupName = "ALL_USERS_GROUP"

$password = convertto-securestring "123" -asplaintext -force
$connection = @{
		 ServerUrl = "localhost:8111"
		 Credential = new-object -typename System.Management.Automation.PSCredential ` -argumentlist "admin", $password
	 }

$client = New-TeamCityConnection -ConnectionDetails $connection

Write-Host "Listing all users in a group" $userGroupName
foreach($user in $client.Users.AllUsersByUserGroup($userGroupName)){
    Write-Host "Found user" $user.Username
    $branchName = "fb/" + $user.Username
    Write-Host "Creating branch" $branchName
    Create-Git-Branch -BranchName $branchName

    $userDetails = $client.Users.Details($user.Username)
    Write-Host "Found user email" $userDetails.Username "with e-mail " $userDetails.Email
    $author = “{0} <{1}>” -f $userDetails.Username, $userDetails.Email
    Write-Host "Will generate commit on-behalf of $author to the branch $branchName" 
    Generate-Git-Commit-With-File-Change -Author $author -Branch $branchName -FilePath "readme.txt"
}