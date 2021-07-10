function Set-DuoAPIKeys{
    Param(
        [parameter(Mandatory=$true)]
        [string]$ikey,
        [parameter(Mandatory=$true)]
        [string]$skey
    )
    $script:ikey = $ikey
    $script:skey = $skey
}