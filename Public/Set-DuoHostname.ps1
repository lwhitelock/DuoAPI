function Set-DuoHostname{
    Param(
        [parameter(Mandatory=$true)]
        [string]$APIHostname
    )
    $script:APIHostname = $APIHostname
}