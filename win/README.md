# Windows Installer

We use [msys2](https://www.msys2.org/) for creating the Windows installer and development on Windows.

## Development

Download [msys2](https://www.msys2.org/) (`msys2-x86_64-xxx.exe`) and follow the install instructions on the [msys2](https://www.msys2.org/) startpage (**Important!**)

Download [Windows SDK](https://learn.microsoft.com/ru-ru/windows/apps/windows-sdk/downloads)

********************************
* Change Servers to worked at C:\msys64\etc\pacman.d\
********************************

* Fork the master branch on dev.gajim.org
* Execute `C:\msys64\msys2_shell.cmd -mingw64`

********************************
* Run `pacman -Sy` to update
* Run `pacman -Su` to upgrade
* Run `pacman -S mingw-w64-x86_64-gtk4`
* Run `pacman -S python3-pip`
********************************

* Run `pacman -S git` to install git
* Run `git clone https://github.com/lidzhik/gajim.git`
* Run `cd gajim/win` to end up where this README exists.
* Execute `cd ~/gajim/win && ./dev_env.sh` to install all the needed dependencies.
* Launch Gajim `cd ~/gajim/ && ./launch.py`

### GTK Inspector

For GTK Inspector to work, add the following registry key

```text
HKEY_CURRENT_USER\Software\GSettings\org\gtk\gtk4\settings\debug
DWORD (32 bits) enable-inspector-keybinding = 1
```

Afterwards press CTRL + SHIFT + I to  activate GTK Inspector

## Build Gajim / Create an Installer

Follow the steps in the Development section, but instead of `cd ~/gajim/win && ./dev_env.sh` execute `cd ~/gajim/win && ./build.sh`.

Both the installer and the portable installer should appear in `C:\msys64\home\USER\gajim\win\_build_root`.

********************************
Add file for Auth: C:\Users\Lidzhik\AppData\Roaming\Gajim\auth_gajim_dgkb.conf
********************************

********************************
Start Installer Silient Mode:
Gajim.exe /S
********************************

## Register Development App from msixbundle

To test Gajim's Microsoft Store msix bundle, the following steps are necessary:

1. Either build the msixbundle locally by running `./build.sh` as described above, or download a nightly build and place it in `C:\msys64\home\USER\gajim\win\_build_root\Gajim.msixbundle`
2. Run `./unpack_msixbundle.sh`, which unpacks the bundle to `C:\msys64\home\USER\gajim\win\_build_root\unpack\Gajim`
3. Open `C:\msys64\home\USER\gajim\win\_build_root\unpack\Gajim` in a PowerShell
4. For easier debugging, change `bin\Gajim.exe` to `bin\Gajim-Debug.exe` in `AppxManifest.xml`, like this: `<Application Id="Gajim" Executable="bin\Gajim-Debug.exe" EntryPoint="Windows.FullTrustApplication">`
5. Now register the app by running `Add-AppxPackage –Register AppxManifest.xml` from a PowerShell
6. Registering the app again requires a version bump in `AppxManifest.xml` (or uninstalling the Gajim app)

To modify code, you can replace `.pyc` files by their equivalent `.py` files from this repo. Gajim's code within the App installation can be found in `C:\msys64\home\USER\gajim\win\_build_root\unpack\Gajim\lib\python3.11\site-packages\gajim`. Code changes do not require to re-register the app.
