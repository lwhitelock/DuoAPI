function _duocanonicalizeParams()
{
    param
    (
        [hashtable]$parameters
    )
    
    if ($parameters.Count -ge 1)
    {
        $ret = New-Object System.Collections.ArrayList

        foreach ($key in $parameters.keys)
        {
            [string]$p = [System.Web.HttpUtility]::UrlEncode($key) + "=" + [System.Web.HttpUtility]::UrlEncode($parameters[$key])
            # Signatures require upper-case hex digits.
            $p = [regex]::Replace($p,"(%[0-9A-Fa-f][0-9A-Fa-f])",{$args[0].Value.ToUpperInvariant()})
            $p = [regex]::Replace($p,"([!'()*])",{"%" + [System.Convert]::ToByte($args[0].Value[0]).ToString("X") })
            $p = $p.Replace("%7E","~")
            $p = $p.Replace("+", "%20")
            $null = $ret.Add($p)
        }

        $ret.Sort([System.StringComparer]::Ordinal)
        [string]$canon_params  = [string]::Join("&", ($ret.ToArray()))
        Write-Debug $canon_params
    } else {
        $canon_params = ""
    }
    return $canon_params
}

function Invoke-DuoSignedRequest {
  Param(
    [string]$Method,
    [string]$Path,
    $Params,
    $Body
  )

  if ($script:SKey -and $script:IKey -and $script:APIHostname) {

    $Date = (Get-Date -Format ("ddd, dd MMM yyyy HH:mm:ss zzz")) -replace '([-+][0-9]{2}):([0-9]{2})$', '$1$2'

    if ($Body){
      
      $SignParams = _duocanonicalizeParams -parameters $Body
      $uri = "https://$script:APIHostname" + "$path"
      Write-Debug "Using Body URL: $uri"
        } else {
      $SignParams = _duocanonicalizeParams -parameters $Params
      $uri = "https://$script:APIHostname" + "$path" + "?" + "$SignParams"      
      Write-Debug "Using Params URL: $uri"
    }

    $Cannon = "$Date", "$($method.ToUpper())", "$(($script:APIHostname).ToLower())", "$Path", "$SignParams"
    $Cannon = $Cannon -join "`n"
    
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA1
    $hmacsha.key = [Text.Encoding]::UTF8.GetBytes($SKey) 
    $hash = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Cannon))
    $signature = ([System.BitConverter]::ToString($hash)).Replace("-", "").ToLower()

    
    $ConvertedSig = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$($script:IKey):$($signature)")) 

    $Headers = @{
      "X-Duo-Date"   = $Date;
      "Content-Type" = "application/x-www-form-urlencoded";
      Authorization  = 'Basic ' + $ConvertedSig;
    }


    $var = invoke-webrequest -uri $uri -headers $Headers -Method $Method -Body $Body

    return ($var.content | convertfrom-json).response

  }
  else {
    Write-Host "Keys or Hostname not found. Please ensure Set-DuoAPIKeys and Set-DuoHostname have both been run" -ForegroundColor Red
  }

}