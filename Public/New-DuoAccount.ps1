function New-DuoAccount{
    Param(
        [parameter(Mandatory=$true)]
        [string]$name
        )
    
    $Body = @{
        name = $name
    }
    
    $Account = Invoke-DuoSignedRequest -method "POST" -path "/accounts/v1/account/create" -body $Body
    Return $Account
}