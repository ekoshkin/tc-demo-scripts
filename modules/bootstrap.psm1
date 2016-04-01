<#
.SYNOPSIS
    A PowerShell Module for interacting with TeamCity
.NOTES
    File Name  : TeamCity-Core
	Author     : Evgeniy Koshkin
	Requires   : PowerShell v2
#>

Write-Host "root module loaded"

# Load in the functions
Write-Host "Loading all the modules from " $PSScriptRoot

$modules = Get-ChildItem -Recurse $PSScriptRoot -Include *.psm1 -Exclude bootstrap.psm1

foreach ($module in $modules) 
{
	Import-Module $module.FullName -Force -DisableNameChecking
	Write-Host "Module loaded" $module.FullName
}

$env:PSUTILSPATH = $PSScriptRoot

try
{
    Add-Type -Path "libs\TeamCitySharp.dll"
}
catch
{
    $_.LoaderExceptions | %
    {
        Write-Error $_.Message
    }
}