# Function to install packages in a specific category
function InstallPackagesInCategory {
    param (
        [string]$category
    )

    $categoryPackages = $categories[$category]

    if ($null -eq $categoryPackages) {
        Write-Host "Invalid category. Exiting script."
        Exit
    }

    foreach ($package in $categoryPackages) {
        Write-Host "Installing $package..."
        winget install -e --id $package
    }

    Write-Host "All $category packages installed successfully."
}

# Define categories and their corresponding packages
$categories = @{
    "Communication" = @("Discord.Discord", "WhatsApp.WhatsApp")
    "Media"         = @("Stremio.Stremio", "Spotify.Spotify", "OBSProject.OBSStudio")
    "System"        = @("7zip.7zip", "Rufus.Rufus", "ALCPU.CoreTemp", "Adobe.Acrobat.Reader.64-bit", "Hibbiki.Chromium")
    "Dev"           = @("Microsoft.PowerShell", "Microsoft.VisualStudioCode", "GodotEngine.GodotEngine")
    "SystemDrivers" = @("Olivia.VIA", "Wacom.WacomTabletDriver")
    "Network"       = @("OpenVPNTechnologies.OpenVPN", "qBittorrent.qBittorrent", "Mega.MEGASync")
    "Games"         = @("EpicGames.EpicGamesLauncher", "Ubisoft.Connect", "Valve.Steam")
}

# Give credits to the author
Write-Host "`nCorte's Install Script for Windows 11"

$exitLoop = $false

while ($exitLoop -eq $false) {

    Write-Host "`nWhat packages do you want to install? [L] List all packages [A] All [C] Install by category [Q] Quit"
    $userInput = Read-Host

    if ($userInput -eq "L") {
        Write-Host "`n=================================================="
        Write-Host "All Packages"
        Write-Host "=================================================="
        foreach ($category in $categories.Keys) {
            $categoryPackages = $categories[$category]
            Write-Host "`n--------------------------------------------------"
            Write-Host "Category: $category"
            Write-Host "--------------------------------------------------"
            $categoryPackages | ForEach-Object { Write-Host $_ }
        }
        Write-Host "`n=================================================="
        Write-Host "All packages listed successfully."
        Write-Host "==================================================`n"
    }

    if ($userInput -eq "A") {
        foreach ($category in $categories.Keys) {
            InstallPackagesInCategory -category $category
        }

        Write-Host "--------------------------------------------------"
        Write-Host "All packages installed successfully."
        Write-Host "=================================================="
        $exitLoop = $true
    }

    if ($userInput -eq "C") {
        # Cycle through all categories and ask the user whether they want to install each one
        foreach ($category in $categories.Keys) {
            $categoryPackages = $categories[$category]
            Write-Host "`n=================================================="
            Write-Host "Category: $category"
            Write-Host "=================================================="
            $categoryPackages | ForEach-Object { Write-Host $_ }
            Write-Host "--------------------------------------------------"
            Write-Host "Do you want to install the $category category? [Y] Yes [N] No"
            $userInput = Read-Host
        
            if ($userInput -eq "Y") {
                InstallPackagesInCategory -category $category
            }
        }
        Write-Host "`n=================================================="
        Write-Host "All prompts have been processed."
        EXIT
    }

    elseif ($userInput -eq "Q") {
        $exitLoop = $true
    }
}