@echo OFF

set CURRENT_DIR=%~dp0

if "%2" == "-project" (
set PROJECT_NAME=%3
) ELSE (
  echo "Please specify a project name"
  goto :EOF
)

if "%4" == "-apigateway_url" (
set GATEWAY_URL=%5
) ELSE (
  echo "Please specify the gateway url"
  goto :EOF
)

IF "%1" == "import" (
goto import
) ELSE (
 goto export
)

:import 
IF EXIST %CURRENT_DIR%/projects/%PROJECT_NAME%/ (
 powershell Compress-Archive -Path %CURRENT_DIR%/projects/%PROJECT_NAME%/* -DestinationPath %CURRENT_DIR%/%PROJECT_NAME%.zip -Force
 curl -i -X POST %GATEWAY_URL%/rest/apigateway/archive -H "Content-Type: application/zip" -H "Accept:application/json" --data-binary @"%CURRENT_DIR%/%PROJECT_NAME%.zip" --user Administrator:manage
 del "%CURRENT_DIR%/%PROJECT_NAME%.zip"
 goto :EOF
) ELSE (
  echo "Project with name %PROJECT_NAME% does not exists"
  goto :EOF
)

:export
IF EXIST %CURRENT_DIR%/projects/%PROJECT_NAME%/ (
 curl %GATEWAY_URL%/rest/apigateway/archive -d @"%CURRENT_DIR%\projects\%PROJECT_NAME%\export_payload.json" --output %CURRENT_DIR%/%PROJECT_NAME%.zip -u  Administrator:manage -H "x-HTTP-Method-Override: GET" -H "Content-Type:application/json"
 powershell Expand-Archive -Path %CURRENT_DIR%/%PROJECT_NAME%.zip -DestinationPath %CURRENT_DIR%/projects/%PROJECT_NAME% -Force
 del "%CURRENT_DIR%/%PROJECT_NAME%.zip"
goto :EOF
) ELSE (
  echo "Project with name %PROJECT_NAME% does not exists"
  goto :EOF
)



 




