$id = Read-Host -Prompt 'Enter the programmer ID {0-9}: '
$pwd = Read-Host -Prompt 'Enter the database password: '

$sound_y = new-Object System.Media.SoundPlayer;
$sound_y.SoundLocation="c:\WINDOWS\Media\notify.wav";

$sound_n = new-Object System.Media.SoundPlayer;
$sound_n.SoundLocation="c:\WINDOWS\Media\chord.wav";
#$sound_y.Play();
Start-Sleep 1
rm id.hex
rm sec.hex

do { 
$ran1 = Get-Random
$ran2 = Get-Random
$ran1h = '{0:x}' -f $ran1
$ran2h = '{0:x}' -f $ran2
#ST-LINK_CLI.exe -c ID=$id FREQ=2000 -P firmware.hex -w32 0x1FFF73F8 $ran1h -w32 0x1FFF73FC $ran2h -Dump 0x1FFF7590 12 id.hex -Dump 0x1FFF73F8 8 sec.hex -Rst
ST-LINK_CLI.exe -c ID=$id FREQ=2000 -P firmware.hex -Dump 0x1FFF7590 12 id.hex -Dump 0x1FFF73F8 8 sec.hex -Rst



#if([System.IO.File]::Exists("id.hex")){
#	if([System.IO.File]::Exists("sec.hex")){
if (Test-Path id.hex) {
	if (Test-Path sec.hex) {
	
		python ..\upload.py .\id.hex .\sec.hex $pwd

		rm id.hex
		rm sec.hex

		if($LASTEXITCODE -eq 1){
			$sound_y.Play()
		}
		else {
			$sound_n.Play()
		}
	
		Start-Sleep 4
	
	}
	else { 

	}
}
else { 
	
	}



} while (1)