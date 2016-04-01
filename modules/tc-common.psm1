<#
.SYNOPSIS
    A PowerShell Module for Core TeamCity REST API functions
.NOTES
    File Name  : TeamCity-Core
	Author     : Evgeniy Koshkin
	Requires   : PowerShell v2
#>

Function New-Project 
{
	param([Hashtable] $ConnectionDetails, [string] $ProjectName)

    $client = New-TeamCityConnection @PSBoundParameters
	return $client.Projects.Create($ProjectName)
}

Function Delete-Project 
{
	param([Hashtable] $ConnectionDetails, [string]$ProjectName)

    $client = New-TeamCityConnection @PSBoundParameters
	return $client.Projects.Delete($ProjectName)
}

Function New-BuildConfig 
{
	param([Hashtable] $ConnectionDetails, [string] $ProjectName, [string] $BuildConfigName)

    $client = New-TeamCityConnection @PSBoundParameters
	return $client.BuildConfigs.CreateConfiguration($ProjectName, $BuildConfigName)
}

Function Post-Raw-BuildStep 
{
	param([Hashtable] $ConnectionDetails, [string] $BuildConfigName, [string] $RawXml)

	$client = New-TeamCityConnection @PSBoundParameters
	$locator = [TeamCitySharp.Locators.BuildTypeLocator]::WithName($BuildConfigName)
	return $client.BuildConfigs.PostRawBuildStep($locator, $RawXml)
}

Function New-TeamCityConnection 
{
	param([Hashtable] $ConnectionDetails)

	$client = New-Object TeamCitySharp.TeamCityClient($ConnectionDetails.ServerUrl, $ConnectionDetails.UseSsl)
	$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConnectionDetails.Credential.Password))
	$userName = $ConnectionDetails.Credential.UserName
	if ($userName.StartsWith("\"))
	{
		$userName = $userName.TrimStart("\")
	}
    $client.Connect($userName, $password)
	return $client
}