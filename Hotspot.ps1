$SSID = "MyHotspot"
$Password = "SecurePassword123"

function Write-SectionHeader {
    param ([string]$Title)
    Write-Host "`n$Title"
    Write-Host ("-" * $Title.Length)
}

function Get-WiFiProfiles {
    Write-SectionHeader -Title "Saved Wi-Fi Profiles"
    try {
        $Profiles = netsh wlan show profiles
        $Profiles | ForEach-Object {
            if ($_ -match "All User Profile") {
                $ProfileName = ($_ -split ":")[1].Trim()
                Write-Host "Profile: $ProfileName"
            }
        }
    } catch {
        Write-Host "Failed to retrieve Wi-Fi profiles Error: $_"
    }
}

Write-SectionHeader -Title "Creating Hotspot"
try {
    netsh wlan set hostednetwork mode=allow ssid=$SSID key=$Password
    Write-Host "Hotspot profile '$SSID' created successfully."
} catch {
    Write-Host "Failed to create hotspot profile. Please check permissions and try again."
    exit
}

Write-SectionHeader -Title "Starting Hotspot"
try {
    netsh wlan start hostednetwork
    Write-Host "Hotspot started successfully."
} catch {
    Write-Host "Failed to start hotspot Please check permissions and try again"
    exit
}

Write-SectionHeader -Title "Hotspot Status"
netsh wlan show hostednetwork

Get-WiFiProfiles

Write-SectionHeader -Title "Hotspot Running"
Read-Host -Prompt "Press Enter to stop the hotspot"

Write-SectionHeader -Title "Stopping Hotspot"
try {
    netsh wlan stop hostednetwork
    Write-Host "Hotspot stopped."
} catch {
    Write-Host "Failed to stop hotspot Please check permissions and try again"
}

Write-SectionHeader -Title "Disabling Hotspot"
try {
    netsh wlan set hostednetwork mode=disallow
    Write-Host "Hotspot disabled successfully."
} catch {
    Write-Host "Failed to disable hotspot check permissions and try again"
}
