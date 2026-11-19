# eXoDOS

My Mods/Addons for the various eXo Projects

## /eXoDOS
Built on the stock eXoDOS v6.04 files.
- Setup eXoDOS.bat - Added NAS support for game download source (eXoDOS Lite)
- eXo/Update/update.bat - Copies update files from the NAS when present, otherwise downloads them. Never offers a version older than the one installed
- eXo/util/install.bat - Added NAS support for game download source (eXoDOS Lite)
- nas.patch - The same changes as a diff against the stock 6.04 files
### Install
1. Copy the contents of this folder over your eXoDOS Lite folder
2. Run Setup eXoDOS.bat and answer Yes to the network share question
3. Enter the path of the full eXoDOS folder on the NAS
### TODO
- If NAS is used
   - run updater after Setup
   - copy LB lincense.xml file if exists
   - make NAS location selectable, if using Mapped Drive
   - make NAS location eXo Root, which can contain all Projects

## /eXoDOS_nasutil
- quick addon used to install & setup NAS support after Setup has already been run
- Supports eXoDOS v6.04 Lite and eXoDREAMM Lite, including both merged into one install
- Run setup_nasutil.bat from eXo\util\eXoDOS_nasutil

## /eXoDREAMM
Built on the stock eXoDREAMM 4.0.0 files. Games are copied from the full eXoDREAMM folder on the NAS the first time they are installed.
- Setup eXoDREAMM.bat - Added the network share question for Lite copies
- eXo/util/install_drm.bat - Added the NAS copy step and an option to delete the local zip on uninstall
- nas.patch - The same changes as a diff against the stock files

## /eXo_Lite
- make_lite.bat - creates a Lite copy of a project without its game zips and adds the NAS scripts from this repo
- Currently supports eXoDREAMM
### Example
```bat
make_lite.bat eXoDREAMM "\\192.168.1.10\Media\Games\eXo\eXoDREAMM" "D:\eXoDREAMM_Lite"
```
Then run Setup eXoDREAMM.bat in the new folder, answer Yes to the network share question, and enter the full eXoDREAMM folder.

## /eXo_Project_Merge
- OpenFolderBox.exe - used to make source folders selectable with a Windows GUI
- merge_projects.bat - copy all eXo Projects to a single install folder and run the installer which merges them into a single install. Run it from the destination folder
### TODO
- TBD

## To Create
- Lite editions of eXoScummVM and eXoWin9x
