@ECHO ON
setlocal enabledelayedexpansion

::--------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------
::VARIABLES
::--------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------
SET project=C:\GitHub\Empire\EmpireTroy\EmpireTroy.Common.Collaboration
REM Notice that project variable above ends with project name below!
SET projectname=EmpireTroy.Common.Collaboration
SET projectcompiledfolder=C:\GitHub\Empire\EmpireTroy\EmpireTroy.Common.Collaboration\bin
REM SET projectcompiledfolder=C:\Temp\EmpireTroy.Common.Collaboration
SET outputdll=UserControlLibrary.dll
REM Configuration is either release or debug, depending on which "mode" you are building against in Visual studio.
SET projectconfiguration=Debug

::--------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------
::LOGIC
::--------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------
call:ReplaceFunction %project% "CodeBehind", "CodeFile"

pause

call:CopyLibraryReference Common, Release, %project%

pause

call:ProjectCompile %projectname%, %project%, %projectcompiledfolder%

pause

call:ProjectMerge %projectcompiledfolder%, %outputdll%, %project%, %projectconfiguration%

pause

call:ReplaceFunction %project% "CodeFile", "CodeBehind"

pause

RMDIR /s /q %projectcompiledfolder%

pause

exit


::---------------------------------------------------------------------------`-----------------------------`
::---------------------------------------------------------------------------`-----------------------------`
::FUNCTIONS
::---------------------------------------------------------------------------`-----------------------------`
::---------------------------------------------------------------------------`-----------------------------`
:CopyLibraryReference <referenceName> <referenceConfiguration> <project>
SET referenceName=%~1
SET referenceConfiguration=%~2
SET project=%~3
REM Solution folder, containing a bunch of Library projects, such as "Common", "ActiveDirectory", "BusinuessLogic" and our UserControlLibrary...
SET lib=C:\GitHub\Empire\EmpireTroy
COPY /Y "%lib%%referenceName%\bin\%referenceConfiguration%\%referenceName%.dll" "%project%\bin\%referenceName%.dll" 
goto:eof

:ProjectCompile <projectname> <project> <projectcompiledfolder>
SET projectname=%~1
SET project=%~2
SET projectcompiledfolder=%~3
REM Path to compiler might vary, also if you want 32 or 64 bit... this might need to change
SET compiler=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe
"%compiler%" -v %projectname% -p "%project%" "%projectcompiledfolder%"
goto:eof


:ProjectMerge <projectcompiledfolder> <outputdll> <project> <projectconfiguration>
SET projectcompiledfolder=%~1
SET outputdll=%~2
SET project=%~3
SET projectconfiguration=%~4
REM Path to merger might vary, also if you want 32 or 64 bit... this might need to change
SET merger=C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\aspnet_merge.exe
"%merger%" "%projectcompiledfolder%" -o %outputdll%
COPY /Y "%projectcompiledfolder%\bin\%outputdll%" "%project%\bin\%projectconfiguration%\%outputdll%"
goto:eof

:ReplaceFunction <projectFolder> <replaceValue> <replaceWith>
set projectFolder=%~1
REM tempfile name can be anything...
set tempfile=%~1\replaceascxbuildv1.txt
set replaceValue=%~2
set replaceWith=%~3
for /f %%f in ('dir /b /s %projectFolder%\*.ascx') do ( 
    for /f "tokens=1,* delims=¶" %%A in ( '"type %%f"') do (
        SET string=%%A
        SET modified=!string:%replaceValue%=%replaceWith%!
        echo !modified! >> %tempfile%
    )
    del %%f
    move %tempfile% %%f
)
goto:eof