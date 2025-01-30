@echo off
setlocal enableDelayedExpansion

set "hexTable=0123456789ABCDEF"

:: Temporary files for ASCII conversions
echo WScript.StdOut.Write Asc(WScript.Arguments(0)) > "%temp%\asc.vbs"
echo WScript.StdOut.Write Chr(WScript.Arguments(0)) > "%temp%\chr.vbs"

if "%~1"=="" (
    echo Usage: %~nx0 [encrypt/decrypt] "input" "key"
    goto :cleanup
)

set "operation=%~1"
set "input=%~2"
set "key=%~3"

if /i "%operation%"=="encrypt" (
    call :encrypt "%input%" "%key%"
) else if /i "%operation%"=="decrypt" (
    call :decrypt "%input%" "%key%"
) else (
    echo Invalid operation. Use encrypt or decrypt.
)

:cleanup
del "%temp%\asc.vbs" "%temp%\chr.vbs" 2>nul
exit /b

:encrypt
setlocal
set "input=%~1"
set "key=%~2"
set "encryptedHex="
set "key_len=0"

:get_key_len_encrypt
if not "!key:~%key_len%,1!"=="" (
    set /a key_len+=1
    goto :get_key_len_encrypt
)

set /a i=0
:encrypt_loop
if "!input:~%i%,1!"=="" goto :encrypt_done

set "char=!input:~%i%,1!"
set /a key_pos=i %% key_len
set "key_char=!key:~%key_pos%,1!"

for /f %%a in ('cscript //nologo "%temp%\asc.vbs" "!char!"') do set asc_char=%%a
for /f %%a in ('cscript //nologo "%temp%\asc.vbs" "!key_char!"') do set asc_key=%%a

set /a xor=asc_char ^^ asc_key

set /a "d1=xor/16, d2=xor%%16"
set "hex1=!hexTable:~%d1%,1!"
set "hex2=!hexTable:~%d2%,1!"

set "encryptedHex=!encryptedHex!!hex1!!hex2!"

set /a i+=1
goto :encrypt_loop

:encrypt_done
echo Encrypted text: !encryptedHex!
endlocal
exit /b

:decrypt
setlocal
set "encryptedHex=%~1"
set "key=%~2"
set "decrypted="
set "key_len=0"

:get_key_len_decrypt
if not "!key:~%key_len%,1!"=="" (
    set /a key_len+=1
    goto :get_key_len_decrypt
)

set /a i=0
set /a hexIndex=0
:decrypt_loop
set "hexPair=!encryptedHex:~%hexIndex%,2!"
if "!hexPair!"=="" goto :decrypt_done

set /a dec=0x!hexPair!

set /a key_pos=i %% key_len
set "key_char=!key:~%key_pos%,1!"

for /f %%a in ('cscript //nologo "%temp%\asc.vbs" "!key_char!"') do set asc_key=%%a

set /a xor=dec ^^ asc_key

for /f %%a in ('cscript //nologo "%temp%\chr.vbs" !xor!') do set dec_char=%%a

set "decrypted=!decrypted!!dec_char!"

set /a i+=1
set /a hexIndex+=2
goto :decrypt_loop

:decrypt_done
echo Decrypted text: !decrypted!
endlocal
exit /b
