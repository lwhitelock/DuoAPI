function Get-DuoIntegrations{
    param (
        [string]$account_id
    )

    $params = ''

    if ($account_id){
        $params = @{
            account_id = $account_id
        }
    }

    $Integrations = Invoke-DuoSignedRequest -method "GET" -path "/admin/v1/integrations" -Params $params
    Return $Integrations
}
