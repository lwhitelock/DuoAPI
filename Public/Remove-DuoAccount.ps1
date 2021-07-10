function Remove-DuoAccount{
    param(
        [string]$account_id
    )
    $body = @{
        account_id = $account_id
    }
    $Result = Invoke-DuoSignedRequest -method "POST" -path "/accounts/v1/account/delete" -body $body
    return $Result
}