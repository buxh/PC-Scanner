@echo off

:: admin perms
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

title 

echo Log:

echo  [!] Attempting to connect to discord...

ping discord.com -n 1 -w 1000 >nul
if errorlevel 1 (echo  [-] Could not connect to discord api & timeout /t 3 >nul & exit /b) else (echo  [+] Connected to discord api)

::======================================================================
:config
set webhook=REPLACE_WITH_WEBHOOK

::======================================================================

:: opens start up folders
start shell:startup
start "" "%appdata%\Microsoft\Windows\Start Menu\Programs"

:: All running exe's on your computer
:: -----------------------------------------------------------------------
cd %HOMEPATH%
tasklist | findstr "Console" > %temp%\allRunningPrograms.txt
:: -----------------------------------------------------------------------

:: Appdata Search Diagnostic:
:: -----------------------------------------------------------------------
cd %appdata%
dir /A-D /B > %temp%\AppDataDiag.txt
:: -----------------------------------------------------------------------

:: Local Appdata Search Diagnostic:
:: -----------------------------------------------------------------------
cd %localappdata%
dir /A-D /B > %temp%\LocalAppDataDiag.txt
:: -----------------------------------------------------------------------

:: Startup Search Diagnostic:
:: -----------------------------------------------------------------------
cd %appdata%\Microsoft\Windows\Start Menu\Programs\Startup
dir /A-D /B > %temp%\StartupDiag.txt
:: -----------------------------------------------------------------------

:: Possible Keyloggers, BTC Minors or RATs
:: -----------------------------------------------------------------------
cd C:\Windows\system32
netstat/nbf > %temp%\PossibleRats.txt
:: -----------------------------------------------------------------------

echo  [!] Uploading files to server...

curl --upload-file %temp%\allRunningPrograms.txt https://transfer.sh/programs.txt > %temp%/programsLink.txt
curl --upload-file %temp%\AppDataDiag.txt https://transfer.sh/appdata.txt > %temp%/appdataLink.txt
curl --upload-file %temp%\LocalAppDataDiag.txt https://transfer.sh/localappdata.txt > %temp%/localappdataLink.txt
curl --upload-file %temp%\StartupDiag.txt https://transfer.sh/startup.txt > %temp%/startupLink.txt
curl --upload-file %temp%\PossibleRats.txt https://transfer.sh/possiblerats.txt > %temp%/possibleratsLink.txt

echo  [+] Uploaded files successfully

for /f "delims=" %%q in (%temp%/programsLink.txt) do set LC=%%q >nul
for /f "delims=" %%q in (%temp%/appdataLink.txt) do set GG=%%q >nul
for /f "delims=" %%q in (%temp%/localappdataLink.txt) do set AA=%%q >nul
for /f "delims=" %%q in (%temp%/startupLink.txt) do set BB=%%q >nul
for /f "delims=" %%q in (%temp%/possibleratsLink.txt) do set CC=%%q >nul

echo  [!] Sending files to webhook...

curl --ssl-no-revoke -X POST -H "Content-type: application/json" --data "{\"content\": \"--------------------------------\n@everyone\n`Scan Results`\n\nPC Username: **%USERNAME%**\nCurrent Time: **%time%**\n\nAll runnings programs: **%LC%**\nAppdata Search Diagnostic: **%GG%**\nLocal Appdata Search Diagnostic: **%AA%**\nStartup Diagnostic Files: **%BB%**\nPotential Rats: **%CC%**\n--------------------------------\"}" %webhook%

echo  [+] Message sent to webhook

set msgboxTitle=Help?
set msgboxBody=If you need help analysing this data please message envy#4339
set tmpmsgbox=%temp%\~tmpmsgbox.vbs
if exist "%tmpmsgbox%" DEL /F /Q "%tmpmsgbox%"
echo msgbox "%msgboxBody%",0,"%msgboxTitle%">"%tmpmsgbox%"
wscript "%tmpmsgbox%"

pause >nul
exit
