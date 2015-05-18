# source http://blogs.technet.com/b/heyscriptingguy/archive/2013/06/16/weekend-scripter-use-powershell-to-manage-auto-connect-wireless-networks.aspx

$SafeNetworks = "LIST", "OF", "SAVE", "NETWORKS"

$guid = (Get-NetAdapter -Name 'WiFi').interfaceGUID
$path = "C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces\$guid"

Get-ChildItem -Path $path -Recurse | Foreach-Object {
    [xml]$c = Get-Content -path $_.fullname
    New-Object pscustomobject -Property @{
        'name' = $c.WLANProfile.name;
        'mode' = $c.WLANProfile.connectionMode;
        'ssid' = $c.WLANProfile.SSIDConfig.SSID.hex;
        'path' = $_.fullname
    } | Foreach-object {
        If($SafeNetworks -notcontains $_.Name) {
            Remove-Item $_.path -whatif
        }
    }
}
