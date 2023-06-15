@echo off
::
dir c:\ /a/s/od/tc > logs\dir_asodtc.txt
dir c:\ /a/s/od/tw > logs\dir_asodtw.txt
dir c:\ /a/s/od/tc/q > logs\dir_asodtcq.txt

echo ----- >> logs\systeminfo.txt
echo systeminfo >> logs\systeminfo.txt
systeminfo >> logs\systeminfo.txt

"System Information\Psloggedon" /accepteula
net use \\127.0.0.1\c$
echo ----- >> logs\systeminfo.txt
echo Psloggedon >> logs\systeminfo.txt
"System Information\Psloggedon" /accepteula >> logs\systeminfo.txt
net use * /delete /yes

echo ----- >> logs\systeminfo.txt
echo Pslist >> logs\systeminfo.txt
"System Information\Pslist" /accepteula -t >> logs\systeminfo.txt

echo ----- >> logs\systeminfo.txt
echo Psservice >> logs\systeminfo.txt
"System Information\Psservice" /accepteula config >> logs\systeminfo.txt

echo ----- >> logs\systeminfo.txt
echo Handle >> logs\systeminfo.txt
"System Information\Handle" /accepteula >> logs\systeminfo.txt

echo ----- >> logs\systeminfo.txt
echo Listdlls >> logs\systeminfo.txt
"System Information\Listdlls" /accepteula >> logs\systeminfo.txt

echo ----- >> logs\networkinfo.txt
echo route print >> logs\networkinfo.txt
route PRINT >> logs\networkinfo.txt

echo ----- >> logs\networkinfo.txt
echo nbtstat -c >> logs\networkinfo.txt
nbtstat -c >> logs\networkinfo.txt
echo ----- >> logs\networkinfo.txt
echo nbtstat -r >> logs\networkinfo.txt
nbtstat -r >> logs\networkinfo.txt
echo ----- >> logs\networkinfo.txt
echo nbtstat -n >> logs\networkinfo.txt
nbtstat -n >> logs\networkinfo.txt

echo ----- >> logs\networkinfo.txt
echo netstat -ano >> logs\networkinfo.txt
netstat -ano >> logs\networkinfo.txt

echo ----- >> logs\networkinfo.txt
echo arp -a >> logs\networkinfo.txt
arp -a >> logs\networkinfo.txt

net use \\127.0.0.1\c$
echo ----- >> logs\networkinfo.txt
echo Net use >> logs\networkinfo.txt
Net use >> logs\networkinfo.txt
echo ----- >> logs\networkinfo.txt
echo Net session >> logs\networkinfo.txt
Net session >> logs\networkinfo.txt
net use * /delete /yes

echo ----- >> logs\networkinfo.txt
echo net share >> logs\networkinfo.txt
net share >> logs\networkinfo.txt

echo ----- >> logs\accountinfo.txt
echo net user >> logs\accountinfo.txt
net user >> logs\accountinfo.txt

echo ----- >> logs\accountinfo.txt
echo net user Administrator >> logs\accountinfo.txt
net user Administrator >> logs\accountinfo.txt

echo ----- >> logs\accountinfo.txt
echo net localgroup >> logs\accountinfo.txt
net localgroup >> logs\accountinfo.txt

echo ----- >> logs\accountinfo.txt
echo net localgroup Administrator >> logs\accountinfo.txt
net localgroup Administrator >> logs\accountinfo.txt

"Collect File Tools\signtool.exe" verify /a /q C:\Windows\*.exe 2>logs\windows_exe.txt
"Collect File Tools\signtool.exe" verify /a /q C:\Windows\*.dll 2>logs\windows_dll.txt
"Collect File Tools\signtool.exe" verify /a /q C:\Windows\System32\*.exe 2>logs\system32_exe.txt
"Collect File Tools\signtool.exe" verify /a /q C:\Windows\System32\*.dll 2>logs\system32_dll.txt
"Collect File Tools\signtool.exe" verify /a /q C:\Windows\syswow64\*.exe 2>logs\syswow64_exe.txt
"Collect File Tools\signtool.exe" verify /a /q C:\Windows\syswow64\*.dll 2>logs\syswow64_dll.txt

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT (
	"Collect File Tools\RawCopy.exe" /FileNamePath:%SYSTEMDRIVE%0 /OutputPath:%~dp0\logs
	"Collect File Tools\RawCopy.exe" /FileNamePath:%SYSTEMROOT%\system32\config\default /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SOFTWARE /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SECURITY /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SAM /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy.exe" /FileNamePath:%userprofile%\NTUSER.DAT /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\AppCompatCacheParser.exe" --csv %~dp0\logs --dt yyyy-MM-ddTHH:mm:ss
	"Collect File Tools\psloglist.exe" /accepteula -g logs\Eventlog\Application.evtx Application
	"Collect File Tools\psloglist.exe" /accepteula -g logs\Eventlog\Security.evtx Security
	"Collect File Tools\psloglist.exe" /accepteula -g logs\Eventlog\System.evtx System
	) ^
else if %OS%==64BIT (
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%SYSTEMDRIVE%0 /OutputPath:%~dp0\logs
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%SYSTEMROOT%\system32\config\default /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SOFTWARE /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SECURITY /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%SYSTEMROOT%\system32\config\SAM /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\RawCopy64.exe" /FileNamePath:%userprofile%\NTUSER.DAT /OutputPath:%~dp0\logs\Registry
	"Collect File Tools\AppCompatCacheParser.exe" --csv %~dp0\logs --dt yyyy-MM-ddTHH:mm:ss
	"Collect File Tools\psloglist64.exe" /accepteula -g logs\Eventlog\Application.evtx Application
	"Collect File Tools\psloglist64.exe" /accepteula -g logs\Eventlog\Security.evtx Security
	"Collect File Tools\psloglist64.exe" /accepteula -g logs\Eventlog\System.evtx System
	) ^
else (
	echo unkonwn operating system
	)
	
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" GTR "6.0" (
	schtasks > logs\Schtask.txt
	) ^
else (
	at > logs\at.txt
	)
endlocal