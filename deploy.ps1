<#
    .SYNOPSIS
    Deploy the resources needed for this What The Hack!
#>

function Download-BicepFiles {
    param (
        [string]$BaseUrl,
        [string[]]$Files
    )    

    foreach ($File in $Files) {
        $path = Split-Path -Parent $File
        if ($path) {
            New-Item -ItemType Directory -Path $path -ErrorAction Ignore
        }

        iwr "$BaseUrl/$File" -Outfile $File
    }
}

Write-Host -Text "      WHAT THE HACK - AZURE OPENAI APPS" -ForegroundColor Green -LinesBefore 1 -LinesAfter 1
Write-Host "created with love by the Americas GPS Tech Team!`n"

if ($env:AZD_IN_CLOUDSHELL -ne "1") {
    Write-Host "Azure Cloud Shell not detected. Please, execute this script from Azure Cloud Shell." -ForegroundColor Red
    return
}

$context = Get-AzContext

Write-Host "The resources will be provisioned in the following subscription:"
Write-Host "`tSubscriptionId: {$context.Subscription.Id}"

Download-BicepFiles `
    -BaseUrl "https://raw.githubusercontent.com/izzymsft/WhatTheHack/xxx-AIAppsFluencyHack/068-AzureOpenAIApps/infra" `
    -Files @("main.bicep", "modules/cosmos.bicep", "modules/document.bicep", "modules/openai.bicep", "modules/redis.bicep", "modules/search.bicep", "modules/servicebus.bicep", "modules/storage.bicep")
