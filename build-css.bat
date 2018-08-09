@echo Off
REM lobocroiden
REM 21.02.2017
REM Run this command after node.js (Node v0.11.10) and npm (npm 2.1.5) is installed
REM also requires less@1.7.0 and less-plugin-clean-css

break >error\error.txt

call node -v
IF %ERRORLEVEL% EQU 0 (
	call:npm_check
	pause
) ELSE (
	MKDIR error
	echo Node JS was not found. Please install.  >error\error.txt
)

goto:EOF

:npm_check
call npm -v
IF %ERRORLEVEL% EQU 0 (
	call:less_check
) ELSE (
	MKDIR error
	echo NPM was not found. Please install.  >error\error.txt
)

goto:EOF

:less_check
call lessc -v
IF %ERRORLEVEL% EQU 0 (
	call:compile_less
) ELSE (
	echo installing Less 1.7.0
	call npm install -g less@1.7.0
	
	echo installing less-plugin-clean-css
	call npm install -g less-plugin-clean-css
	
	echo installation completed
	call:compile_less
)
goto:EOF

:compile_less
MKDIR css

@echo Off >nul
dir /b less\*.less >tmp
break >Combined.less
FOR /f "tokens=*" %%i IN (tmp) DO (
	echo @import "less/%%i"; >>Combined.less
)
del tmp

CALL lessc Combined.less > css\style.css
CALL lessc --clean-css Combined.less > css\style.min.css

echo Successfully generated css file 
goto:EOF

:EOF

