$ssid = 'WLAN SSID'
$password = 'WLAN PASSWORD'

function Convert-ToCHexString
{
    param ([String] $str)
    $ans = ''
    [System.Text.Encoding]::ASCII.GetBytes($str) | % {
        $ans += "{0:X2}" -f $_
    }
    return $ans
}

$tmpName = $env:temp + '\automatic-created-wlan-profile.tmp.xml'

$ssidhex = Convert-ToCHexString $ssid
(Get-Content .\template.xml) -replace '{{ PASSWORD }}',$password -replace '{{ SSIDNAME }}',$ssid -replace '{{ SSIDHEX }}',$ssidhex | Set-Content $tmpName

echo $tmpName
Get-Content $tmpName
netsh wlan add profile filename="$tmpName"

Remove-Item $tmpName
