# Steam Machine Setup
This script is good for users that either cannot run Steam OS, Bazzite, ChimeraOS, etc, because of issues that involve NVidia drivers not being up to snuff in Linux or just do not want to run Linux at all. This will set the user shell as Steams Big Picture mode automatically replacing Windows Explorer, thus giving a true console experience with Steam. 

## What this script does
- Checks registry for Steam installation path
- Verifies path and Steam executable is installed
- Checks to see if shell is alredy set
- Sets user shell to Steam Big Picture mode
- Asks user to restart to apply change

### How to use script to set user shell
- Download or copy set_steam_shell.ps1 scipt to computer
- As the user you plan to use Steam with open a non administrative Powershell terminal window
- In the terminal window CD to the location the script is located in (if in downloads)
- ```powershell
  cd downloads
  powershell -ep bypass .\set_steam.shell.ps1
- Script will automatically test for Steam install path and set registry key accordingly
- Follow prompt to reboot to apply change

### Recommendations
If setting this up for the fist time I would highly recommend doing a fresh installation of Windows. Perferably make a seperate administrative account, and the account being used to log into Steam Big Picture as a normal user account. For the user account a login password is not required as it will be used to boot into Steam Big Picture mode automatically.

### Set Windows Explorer back as shell from Steam
If you need to set Windows Explorer back as the shell temporarily (ie: install Windows updates, install other programs, manage Windows settings, etc) this can be done via a custom script that we can deploy from steam before exiting Big Picture mode.

```powershell
while ($true) {
  $steam = get-process -name Steam

  if ($null -eq $steam) {
    start-process C:\Windows\explorer.exe  
    break
  }
  sleep -seconds 1
}
```
Save this as Start_Explorer.ps1, we can then use a tool like iexpress to build it into an exe to import into Steam. Once the exe is built, import it to Steam via the Add a Non-Steam Game to My Library option. Once imported run before exting Steam and Windows Explorer will automatically re-enable.
