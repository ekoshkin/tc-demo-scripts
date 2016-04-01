<#
.SYNOPSIS
    A PowerShell Module for Git operations
.NOTES
    File Name  : Git
	Author     : Evgeniy Koshkin
	Requires   : PowerShell v2
#>

Function Generate-Git-Commit-With-File-Change 
{
    param([string]$Author, [string] $Branch, [string] $FilePath)

    Start-Git -ArgumentList "checkout $Branch"
    $date = Get-Date
    "last modified by $Author on $date" | out-file -filepath $FilePath
    $argumentList = “commit -a --author=""{0}"" -m ""modified by {0}""” -f $Author
    Start-Git -ArgumentList $argumentList
}

Function Create-Git-Branch
{
    param([string] $BranchName)
    Start-Git -ArgumentList "checkout master"
    Start-Git -ArgumentList "branch $BranchName"
    Start-Git -ArgumentList "checkout $BranchName"
}

Function Start-Git
{
    param([String[]] $ArgumentList)
    Write-Host "Running git.exe with arguments: $ArgumentList"
    $process = Start-Process -FilePath "git.exe" -ArgumentList $ArgumentList -Wait -WindowStyle Hidden -PassThru
    Write-Host "Process finised with code" $process.ExitCode
}