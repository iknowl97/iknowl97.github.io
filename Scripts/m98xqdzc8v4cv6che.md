```cmd
@echo off
echo Detecting processes using port 8000...

for /f "tokens=1-5" %%a in ('netstat -ano ^| findstr ":8000"') do (
    for /f "tokens=1-5" %%f in ('tasklist /fi "pid eq %%e" ^| findstr /i "exe"') do (
        echo Protocol: %%a
        echo Local Address: %%b
        echo State: %%d
        echo PID: %%e
        echo Process Name: %%f
        echo.
    )
)

echo Detection complete.
pause
```