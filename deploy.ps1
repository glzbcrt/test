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

Write-Host "`n`tWHAT THE HACK - AZURE OPENAI APPS" -ForegroundColor Green
Write-Host "created with love by the Americas GPS Tech Team!`n"

if ($env:AZD_IN_CLOUDSHELL -ne "1") {
    Write-Host "Azure Cloud Shell not detected. Please, execute this script from Azure Cloud Shell." -ForegroundColor Red
    return
}

$context = Get-AzContext

Write-Host "The resources will be provisioned in the following subscription:"
Write-Host -NoNewline "`t-       TenantId: " 
Write-Host -ForegroundColor Yellow $context.Tenant.Id
Write-Host "`t- SubscriptionId: $context.Subscription.Id"
Write-Host "`t- Resource Group: wth_azureopenai_apps"
Write-Host "`t-         Region: East US"

Download-BicepFiles `
    -BaseUrl "https://raw.githubusercontent.com/izzymsft/WhatTheHack/xxx-AIAppsFluencyHack/068-AzureOpenAIApps/infra" `
    -Files @("main.bicep", "modules/cosmos.bicep", "modules/document.bicep", "modules/openai.bicep", "modules/redis.bicep", "modules/search.bicep", "modules/servicebus.bicep", "modules/storage.bicep")
