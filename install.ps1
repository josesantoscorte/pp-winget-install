# Function to install winget if it is not already installed
function InstallWinget {
    try {
        $wingetInstalled = winget --version
    } catch {
        $wingetInstalled = $null
    }

    if ($null -eq $wingetInstalled) {
        Write-Host "`n❌ Winget is not installed. You need to install it to continue."
        Write-Host "🌐 https://learn.microsoft.com/en-us/windows/package-manager/winget/"
        EXIT
    } else {
        Write-Host "`n✅ Winget is installed."
    }
}

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

    Write-Host "✅ All $category packages installed successfully."
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
Write-Host "`n✨ Corte's Install Script for Windows 11 "
Write-Host "🌐 https://github.com/josesantoscorte/pp-winget-install.git"

# Call the InstallWinget function
InstallWinget

$exitLoop = $false

while ($exitLoop -eq $false) {

    Write-Host "`n❔ What packages do you want to install? 
    `n - 🅰️ [A] All 
    `n - ♻️ [C] Install by category 
    `n - 📂 [L] List packages 
    `n - ❌ [Q] Quit`n"
    $userInput = Read-Host "> "

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

    if ($userInput -eq "W") {
        InstallWSL
    }

    if ($userInput -eq "A") {
        foreach ($category in $categories.Keys) {
            InstallPackagesInCategory -category $category
        }

        Write-Host "--------------------------------------------------"
        Write-Host "✅ All packages installed successfully."
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
            Write-Host "`n❔ Do you want to install the $category category? 
            `n - ✔️ [Y] Yes
            `n - ❌ [N] No`n"
            $userInput = Read-Host "> "
        
            if ($userInput -eq "Y") {
                InstallPackagesInCategory -category $category
            }
        }
        Write-Host "`n=================================================="
        Write-Host "✅ All prompts have been processed.`n"
        EXIT
    }

    elseif ($userInput -eq "Q") {
        $exitLoop = $true
    }
}