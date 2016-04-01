Function List-Configurations-WithRequirement 
{
    param([Hashtable] $ConnectionDetails, [string] $RequirementType, [string] $AgentPropertyName)
    $client = New-TeamCityConnection @PSBoundParameters
	$counter = 0
	foreach($buildConfigDescr in $client.BuildConfigs.All())
	{
		$buildConfig = $client.BuildConfigs.ByConfigurationId($buildConfigDescr.id)
		Write-Host "Processing configuration" $buildConfig
		if($buildConfig.agentRequirements)
		{
			foreach($requirement in $buildConfig.agentRequirements.agentRequirement)
			{
				if($requirement.type.Equals($RequirementType))
				{
					foreach($property in $requirement.properties.property)
					{
						if($property.value.StartsWith($AgentPropertyName))
						{
							Write-Host $buildConfig.name "explicitly requires" $AgentPropertyName 
							$counter++
						}
					}
				}
			}
		}
	}
	return $counter
}

Function Convert-Requirements 
{
    param([Hashtable] $ConnectionDetails, [string] $RequirementType, [string] $SourceAgentPropertyName, [string] $TargetAgentPropertyName)
    $client = New-TeamCityConnection @PSBoundParameters
	$counter = 0
	foreach($buildConfigDescr in $client.BuildConfigs.All())
	{
			$buildConfig = $client.BuildConfigs.ByConfigurationId($buildConfigDescr.id)
			Write-Host "Processing configuration" $buildConfig
			if($buildConfig.agentRequirements)
			{
				foreach($requirement in $buildConfig.agentRequirements.agentRequirement)
				{
					if($requirement.type.Equals($RequirementType))
					{
						foreach($property in $requirement.properties.property)
						{
							if($property.value.StartsWith($SourceAgentPropertyName))
							{
                                [System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
                                [System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("agent-requirement")
                                $oXMLDocument.appendChild($oXMLRoot)
                                $oXMLRoot.SetAttribute("type", "exists")
                                $propertiesElement = $oXMLDocument.CreateElement("properties")
                                $oXMLRoot.appendChild($propertiesElement)
                                $propertyElement = $oXMLDocument.CreateElement("property")
                                $propertyElement.SetAttribute("value", $TargetAgentPropertyName)
                                $propertyElement.SetAttribute("name", "property-name")
                                $propertiesElement.AppendChild($propertyElement)

                                $rawRequirementsXml = $oXMLDocument.OuterXml

                                Write-Host "Updating requirement on" $SourceAgentPropertyName "to" $rawRequirementsXml

                                $buildTypeLocator = [TeamCitySharp.Locators.BuildTypeLocator]::WithId($buildConfig.id)
								$client.BuildConfigs.PostRawAgentRequirement($buildTypeLocator, $rawRequirementsXml)
                                $client.BuildConfigs.DeleteAgentRequirement($buildTypeLocator, $requirement.id)

								$counter++
							}
						}
					}
				}
			}
	}
	return $counter
}

Function Delete-Requirements 
{
    param([Hashtable] $ConnectionDetails, [string] $RequirementType, [string] $AgentPropertyName)
    $client = New-TeamCityConnection @PSBoundParameters
	$counter = 0
	foreach($buildConfigDescr in $client.BuildConfigs.All())
	{
			$buildConfig = $client.BuildConfigs.ByConfigurationId($buildConfigDescr.id)
			Write-Host "Processing configuration" $buildConfig
			if($buildConfig.agentRequirements)
			{
				foreach($requirement in $buildConfig.agentRequirements.agentRequirement)
				{
					if($requirement.type.Equals($RequirementType))
					{
						foreach($property in $requirement.properties.property)
						{
							if($property.value.StartsWith($AgentPropertyName))
							{
                                Write-Host "Deleting requirement on" $AgentPropertyName
                                $client.BuildConfigs.DeleteAgentRequirement($buildTypeLocator, $requirement.id)
								$counter++
							}
						}
					}
				}
			}
	}
	return $counter
}