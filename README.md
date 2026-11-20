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
- Supports eXoDOS v6.04 Lite, eXoDREAMM Lite, eXoScummVM Lite and eXoWin9x Lite, including merged installs
- Run setup_nasutil.bat from eXo\util\eXoDOS_nasutil

## /eXoDREAMM
Built on the stock eXoDREAMM 4.0.0 files. Games are copied from the full eXoDREAMM folder on the NAS the first time they are installed.
- Setup eXoDREAMM.bat - Added the network share question for Lite copies
- eXo/util/install_drm.bat - Added the NAS copy step and an option to delete the local zip on uninstall
- nas.patch - The same changes as a diff against the stock files

## /eXoScummVM
Built on the stock eXoScummVM files. Games are copied from the full eXoScummVM folder on the NAS the first time they are installed.
- Setup eXoScummVM.bat - Added the network share question for Lite copies
- eXo/util/install_svm.bat - Added the NAS copy step and an option to delete the local zip on uninstall
- nas.patch - The same changes as a diff against the stock files

## /eXoWin9x
Built on the stock eXoWin9x files. Games are copied from the matching year folder of the full eXoWin9x folder on the NAS the first time they are installed.
- Setup eXoWin9x.bat - Added the network share question for Lite copies
- eXo/util/install9x.bat - Added the NAS copy step and an option to delete the local zip on uninstall
- eXo/util/9x*.bat - Launchers no longer try to start a game that was not installed
- nas.patch - The same changes as a diff against the stock files

## /eXo_Lite
- make_lite.bat - creates a Lite copy of a project without its game zips and adds the NAS scripts from this repo
- Currently supports eXoDREAMM, eXoScummVM and eXoWin9x
### Example
```bat
make_lite.bat eXoDREAMM "\\192.168.1.10\Media\Games\eXo\eXoDREAMM" "D:\eXoDREAMM_Lite"
```
Then run Setup eXoDREAMM.bat in the new folder, answer Yes to the network share question, and enter the full eXoDREAMM folder.

## /eXoDOS_MediaLite
A Lite edition of the eXoDOS Media Pack, about 2 GB instead of about 240 GB. It keeps the LaunchBox images, platform lists and small launch files. The books, catalogs, magazines, soundtracks and videos stay on the NAS, and each one is copied the first time it is opened.
- make_media_lite.bat - makes the Lite zips from the full Media Pack. Put the files from its Content folder in the Content folder of an eXoDOS install and run Setup again, the same as the full Media Pack
- make_media_lite.ps1 - does the work for make_media_lite.bat. Use -Report to only list what would be kept and left on the share
- media_nas.bat - goes in eXo\util. LaunchBox opens every Lite item through it. It copies the item from the Media Pack zips on the share the first time, then opens it. The share folder is asked for on first use and saved in eXo\util\nas_media.conf
- Items are copied whole: a book's or video's folder, one magazine PDF, one cover disc or issue folder, or one soundtrack zip. Big Blue Disk and GameBytes stay local because all their issues share one folder
- Media that no LaunchBox item uses (about 1.6 GB) is left out
- The King's Quest V soundtrack entry in the stock pack points at a file name that is not in the zip, so it is left as it is
```
make_media_lite.bat "\\192.168.1.10\Media\Games\eXo\eXoDOS Media Pack\eXoDOS" "D:\eXoDOS Media Pack Lite"
```

## /eXo_Project_Merge
- OpenFolderBox.exe - used to make source folders selectable with a Windows GUI
- merge_projects.bat - copy all eXo Projects to a single install folder and run the installer which merges them into a single install. Run it from the destination folder
- merge_eXo.bat - merges every supported project into one new folder in a single run. It asks for Regular or Lite, the folder that holds the project folders (for example \\192.168.1.10\Media\Games\eXo) and the destination, then copies the projects, runs Setup once and, for Lite, sets up the NAS game copies for each project. Run it from this repo, since Lite merges use the NAS scripts in the project folders here
  - Regular: full copies of eXoWin3x, eXoDOS, eXoDREAMM, eXoScummVM, eXoDemoScene, eXoIF and eXoWin9x
  - Lite: eXoDOS (the official eXoDOS_Lite folder when present), eXoDREAMM, eXoScummVM and eXoWin9x without their games, with optional full copies of the projects that have no Lite version
  - Offers the eXoDOS Media Pack when it is found. In Lite mode it offers the Lite Media Pack, Full or None. Lite uses an eXoDOS Media Pack Lite folder next to the projects when there is one, otherwise it makes one in the new install
  - merge_eXo.bat /dryrun lists what would be copied without changing anything
### TODO
- TBD

## To Create
- Lite edition of eXoWin3x
