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
- quick addon used to install & setup NAS support for eXoDOS v6.04, after Setup has already been run
### TODO
- N/A - depricated

## /eXo_Project_Merge
- OpenFolderBox.exe - used to make source folders selectable with a Windows GUI
- merge_projects.bat - copy all eXo Projects to a single install folder and run the installer which merges them into a single install. Run it from the destination folder
### TODO
- TBD

## To Create
- Convert to Lite Edition
