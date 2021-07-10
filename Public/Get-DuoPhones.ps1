function Get-DuoUsers{
    param (
        [string]$account_id
    )

    $params = ''

    if ($account_id){
        $params = @{
            account_id = $account_id
        }
    }

    $Users = Invoke-DuoSignedRequest -method "GET" -path "/admin/v1/users" -Params $params
    Return $Users
}
