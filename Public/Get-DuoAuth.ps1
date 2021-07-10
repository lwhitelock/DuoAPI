function Get-DuoAuth{
    param (
        [string]$user_id,
        [string]$username,
        [string]$ipaddr,
        [string]$hostname
    )

    $body = @{}

    if ($user_id){
        $body.add('user_id', $user_id)
    }
    
    if ($username){
        $body.add('username', $username)
    }

    if ($ipaddr){
        $body.add('ipaddr', $ipaddr)
    }

    if ($hostname){
        $body.add('hostname', $hostname)
    }

    $body.add('factor', 'auto')
    $body.add('device', 'auto')

    $Auth = Invoke-DuoSignedRequest -method "POST" -path "/auth/v2/auth" -Body $Body
    Return $Auth
}
