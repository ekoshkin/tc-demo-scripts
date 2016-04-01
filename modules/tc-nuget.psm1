<#
.SYNOPSIS
    A PowerShell Module for Nuget-specific TeamCity configuration tasks
.NOTES
    File Name  : TeamCity-Nuget
	Author     : Evgeniy Koshkin
	Requires   : PowerShell v2
#>

Function Get-NugetPublish-RawXml
{
	param([Hashtable] $ConnectionDetails, [string] $StepName)

	$templatePath = Join-Path $PSScriptRoot "nuget-publish-step-template.xml"
	[xml] $doc = Get-Content $templatePath
	return $doc.OuterXMl
}