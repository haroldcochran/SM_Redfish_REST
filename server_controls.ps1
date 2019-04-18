# HTTP BASIC Authorization - BMC account and password as base64 encoded ASCII
$rest_creds = Get-Credential -Message "Enter credentials for BMC user"
$rest_user = $rest_creds.UserName
$rest_pass = $rest_creds.GetNetworkCredential().Password

$basic_auth = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($rest_user + ":" + $rest_pass))

# Authentication to pass via header
$headers = @{ Authorization = "Basic $basic_auth" }

Function power_On
    {
        param($server)
        Invoke-RestMethod -Uri https://$server/redfish/v1/Systems/1/Actions/ComputerSystem.Reset -Method POST -Headers $headers -Body '{"ResetType": "On"}' -ContentType "application/json" -SkipCertificateCheck
    }

    Function power_Off
    {
        param($server)
        Invoke-RestMethod -Uri https://$server/redfish/v1/Systems/1/Actions/ComputerSystem.Reset -Method POST -Headers $headers -Body '{"ResetType": "ForceOff"}' -ContentType "application/json" -SkipCertificateCheck
    }

$choice_IP = Read-Host "Server IP"
$choice_Function = Read-Host @"
1.Power On
2.Power Off
Which action for server $choice_IP?
"@

IF ($choice_Function -eq "1")
    {
        power_On -server $choice_IP
    }

ELSEIF ($choice_Function -eq "2")
    {
        power_off -server $choice_IP
    }
else
    {
        Write-Host "...what did you choose?"
    }
