@Echo off

Title Mulitplue install Tool
::모바일QA실 모바일플랫폼QA팀 모바일QC 박경공, 정송희
::ver.1 apk 다중 설치
echo.

Echo. # Menus
:: 메뉴
Echo. 0. Reboot ADB Server
::0. ADB server 재실행
Echo. 1. install APK
::1. APK 설치
Echo. 2. run apk
::2. apk 실행
Echo. 3 OS/API Level Check
::3. OS/API Level 확인
Echo. End
::툴 종료
echo.

Echo. # Step 1. The host computer waits for the Andorid devices to USB connection.
echo.
adb wait-for-device
::단말이 연결 대기
adb devices -l
::연결된 단말 리스트 확인
echo. 

Echo. # Step 2. Select Menus
echo.

:menu
Set /P me=Menus:
:: Menus의 값을 입력 받고 Menus를 me로 정의
if %me% equ 0 (
	goto reboot
:: 메뉴에서 0번 입력 시 ADB server 재실행
)else if %me% equ  1 ( 
	goto install
:: 메뉴에서 1번 입력 시 APK 설치
)else if %me% equ 2 ( 
	goto run
:: 메뉴에서 2번 입력 시 APK 실행
)else if %me% equ 3 (
	goto check
:: 메뉴에서 3번 입력 시 OS/API Level 확인
)else (
	goto end
:: 메뉴에서 다른 번호 입력 시 툴 중단(pause)
)

:reboot
echo ">> kill-server"
adb kill-server
::adb server 종료
echo.

echo ">>start-server"
adb start-server
::adb server 실행
echo.

goto menu
:: 메뉴로 이동

:install
echo.
set /P apk=apk name : 
:: adk name을 입력받고 apk name을 apk로 정의

for /L %%i in  (0, 1, 10) do (
	adb -t %%i install %apk%.apk
	echo.
)
:: 1~10까지의 transport_id에 입력한 apk를 순차적으로 설치함

adb -t 1 shell pm list package | FINDSTR com.nexon.*
echo.
:: 1번 포트의 디바이스에 설치된 패키지 중 'com.nexon.*'문자열을 가진 패키지 목록을 출력

goto menu
:: 메뉴로 이동

:run
echo.
set /P pkg=Package Name :
:: Package Name을 입력받고 Package Name을 pkg로 정의

for /L %%i in  (0, 1, 10) do (
	adb -t %%i shell am start -n %pkg%/%pkg%.MainActivity
)
:: 1~10까지의 transport_id에 입력한 Package Name을 순차적으로 실행함
echo.

goto menu
:: 메뉴로 이동

:check
set /P did=devices ID:
:: Devices ID를 입력받고 devices ID 를 did로 정의

echo. OS version :
adb -s %did% shell getprop ro.build.version.release
:: 입력한 디바이스의 OS 버전 확인
echo. API version :
adb -s %did% shell getprop ro.build.version.sdk
:: 입력한 디바이스의 API 버전 확인
goto menu
:: 메뉴로 이동

:end

pause
