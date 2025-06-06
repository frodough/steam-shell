## Defining the registry locations to search
$regloc = @("hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "hklm\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*")

foreach ($loc in $regloc) {
    ## Steam does not have an entry for install location in the registry so grabbing the uninstall string and testing the path 
    $steamInstall =  (get-itemproperty registry::$loc | ? {$_.displayname -eq "Steam"}).uninstallstring
}

write-host "Checking registry for Steam entry: " -nonewline

if ($steamInstall) {
    write-host "Success" -fore green

    ## If the registry contains an entry grabbing it and testing to see if the Steam executable exists at that path
    $path = ($steamInstall).Substring(0, $steamInstall.LastIndexOf("\"))
    $exe = "\Steam.exe"
    $fullpath = join-path -path $path -childpath $exe

    write-host "Checking for path for Steam executable: " -nonewline
    if (test-path $fullpath) {
        write-host "Executable found at $($fullpath)" -fore yellow
        sleep -seconds 1

        write-host "Checking for shell entry in registry: " -nonewline
        $regpath = (get-itemproperty registry::"hkcu\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").shell

        if ($null -eq $regpath) {
            write-host "No entry found setting Steam Big Picture mode as user shell" -fore yellow
            sleep -seconds 1

            ## Setting the registry entry to make Steam the shell for the current user
            write-host "Setting registry entry: " -nonewline
            try {
                set-itemproperty registry::"hkcu\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name Shell -value "`"$($fullpath)`" -bigpicture"

                write-host "Success" -fore green
                sleep -seconds 1

                ## Restarting computer to apply change
                $answer = read-host "Restart computer to apply change? [y/n]"

                if ($answer -eq "y") {
                    restart-computer
                }
                else {
                    exit
                }
            }
            catch { $_.exception.message } 
        }
        else {
            write-host "Shell entry detected" -fore yellow
            sleep -seconds 1

            ## Overwriting the registry entry to make Steam the shell for the current user
            write-host "Overwriting registry entry: " -nonewline

            try {
                set-itemproperty registry::"hkcu\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name Shell -value "`"$($fullpath)`" -bigpicture"

                write-host "Success" -fore green
                sleep -seconds 1

                ## Restarting computer to apply change
                $answer = read-host "Restart computer to apply change? [y/n]"

                if ($answer -eq "y") {
                    restart-computer
                }
                else {
                    exit
                }
            }
            catch { $_.exception.message }
         }
    } 
    else {
        write-host "ERROR: Steam executable not found in $($path)" -fore red
    }
}
else {
    write-host "Steam not detected! Please install Steam and run script again" -fore yellow
}