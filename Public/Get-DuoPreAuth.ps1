function Get-DuoPreAuth{
    param (
        [string]$user_id,
        [string]$username,
        [string]$ipaddr,
        [string]$hostname,
        [string]$trusted_device_token
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

    if ($trusted_device_token){
        $body.add('trusted_device_token', $trusted_device_token)
    }


    $PreAuth = Invoke-DuoSignedRequest -method "POST" -path "/auth/v2/preauth" -Body $Body
    Return $PreAuth
}
