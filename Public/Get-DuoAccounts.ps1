function Get-DuoAccounts{
    $Accounts = Invoke-DuoSignedRequest -method "POST" -path "/accounts/v1/account/list"
    Return $Accounts
}