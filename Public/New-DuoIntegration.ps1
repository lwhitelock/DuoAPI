function New-DuoIntegration{
    Param(
        [parameter(Mandatory=$true)]
        [string]$name,
        [string]$type,
        [string]$account_id
        )
    
    $Body = @{
        name = $name
        type = $type
        account_id = $account_id
    }
    
    $Account = Invoke-DuoSignedRequest -method "POST" -path "/admin/v1/integrations" -body $Body
    Return $Account
}