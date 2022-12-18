# PC-Scanner
https://solo.to/buxh

## Disclaimer
- Not the best but it gets the job done kinda
- This was created in November 2020
- **THIS SHOULD NOT REPLACE YOUR CURRENT ANTI-VIRUS SCANNER**
- I have not coded in batch in over a year because it's terrible so don't ask me for help just look it up on google 💀

## Features
- Attempts to find active connections
- Collects all running exe's names
- Locates all local appdata & appdata file names
- Gathers all start up file names
- Opens start up folders
- Grants you the ability to upload the file names and send them to a discord webhook
- Uploaded via curl to [transfer.sh](https://transfer.sh)
- Very easy to use

## How to use
i. Create a [webhook](https://www.socialoomph.com/help/view/help_discord_webhook_how/).

ii. Right click and edit `Scanner.bat` then replace "REPLACE_WITH_YOUR_WEBHOOK" on [line 17](https://github.com/buxh/PC-Scanner/blob/main/Scanner.bat#L17) with your webhook.
```bat
set webhook=REPLACE_WITH_YOUR_WEBHOOK
```
iii. If done successfully then it should look something like this.
```bat
set webhook=https://discord.com/api/webhooks/172979283729726/URnyhuVL24vJ9pAFOeBFHAZSU2eCRAEEQSLl1NPrbYWDrsO8SLiNwmQ5vvxDmj_nkZqg
```
iv. Save the file and run!

## Sample
```bat
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

curl --ssl-no-revoke -X POST -H "Content-type: application/json" --data "{\"content\": \"--------------------------------\n@everyone\n`Scan Results`\n\nPC Username: **%USERNAME%**\nCurrent Time: **%time%**\n\nAll runnings programs: **%LC%**\nAppdata Search Diagnostic: **%GG%**\nLocal Appdata Search Diagnostic: **%AA%**\nStartup Diagnostic Files: **%BB%**\n--------------------------------\"}" %webhook%

echo  [+] Message sent to webhook
```

## Help
If you are in need of help open an issue or contact me on discord: `envy#4339`

If the discord is invalid the updated name & tag will be on my [github profile](https://github.com/buxh) or [here](https://solo.to/buxh)
