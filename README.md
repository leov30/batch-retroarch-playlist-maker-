# batch-retroarch-playlist-maker-
simple batch script to create playlist for retroarch PC

needs xidel.exe to extract datafile information

uses a vbs script to rmove the carriage return character from the playlist

# usage
just drag and drop a folder with roms. will add anything from the folder and subfolders its recursive.

rom path its the same as the roms, db name, and playlist name will be the folder name

core path and name can be added by editing the script, its set to auto as default.

drag and drop a .dat .xml file (will need https://www.videlibri.de/xidel.html) to create arcade.txt, the script will use the titles from that file for the playlist label
if not match was found in arcade.txt the script will just use the file name as label
