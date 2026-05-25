@echo off
if not exist Packages (
	echo Packages folder missing, running wally install...
	wally install || exit /b 1
)
rojo serve default.project.json
pause
