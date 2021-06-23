::Compress content in srcDir to separate archives in dstDir
set srcDir=%programfiles%\Software Portable
set dstDir=%homepath%\OneDrive - the9\Documents\Archive - Compressed\Software Portable
set exe=%programfiles%\7-Zip\7z.exe
set runDir=%cd% & cd "%srcDir%" & set stamp=%date:~6,4%-%date:~0,2%-%date:~3,2%
::compress first level subdirs into separate archives
for /d %%X in (*) do "%exe%" a "%dstDir%\%stamp%_%%X_%ComputerName%.zip" "%%X\"  >>"%dstDir%\%stamp%_Log.txt" 2>&1
::compress files directly within srcDir into one archive
for %%X in (.\*) do "%exe%" a "%dstDir%\%stamp%_#Files-noDir_%ComputerName%.zip" "%%X"  >>"%dstDir%\%stamp%_Log.txt" 2>&1
cd %runDir%