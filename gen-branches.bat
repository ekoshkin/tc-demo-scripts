@echo off

SET TEAMCITY_RUNALL_CURRENT_DIR=%CD%
cd /d %~dp0\..\buildAgents\

IF ""%1"" == ""start"" goto run
IF ""%1"" == ""stop"" goto run

goto usage

:run

echo %1ing TeamCity agents...

for /f "delims=" %%D in ('dir /a:d /b') do (
   echo calling %%~fD\bin\agent.bat ...
   call %%~fD\bin\agent.bat %1 %2
)

goto done

:usage
echo "usage: runall.bat (start|stop[ force])"
goto done

:done

cd /d %TEAMCITY_RUNALL_CURRENT_DIR%
