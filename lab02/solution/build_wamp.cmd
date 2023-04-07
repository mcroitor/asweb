@echo off
set PATH=%PATH%;%CD%\tools\;
set HTTP_SERVER_URL=https://www.apachehaus.com/downloads/httpd-2.4.52-o111m-x64-vc15.zip
set MYSQL_SERVER_URL=https://mirror.ihost.md/mariadb//mariadb-10.6.5/winx64-packages/mariadb-10.6.5-winx64.zip
set PHP_SERVER_URL=https://windows.php.net/downloads/releases/php-8.1.2-Win32-vs16-x64.zip

set INIT_DIR=%CD%
set CONFIG_DIR=%INIT_DIR%\configs
set SERVER_DIR=d:\server
set WWW_DIR=%SERVER_DIR%\www
set TMP_DIR=%SERVER_DIR%\tmp
set LOG_DIR=%SERVER_DIR%\logs
set USR_DIR=%SERVER_DIR%\usr

set MYSQL_PASSWORD=password

rem create structure of server
echo create structure of server - start
mkdir %SERVER_DIR%
mkdir %WWW_DIR%
mkdir %TMP_DIR%
mkdir %LOG_DIR%
mkdir %USR_DIR%
echo create structure of server - done

rem download files
echo download files - start
echo download Apache HTTP Server
if NOT EXIST %TMP_DIR%\httpd.zip (
    wget %HTTP_SERVER_URL% -O %TMP_DIR%\httpd.zip
)
echo done

echo download MySQL Server
IF NOT EXIST %TMP_DIR%\mariadb.zip (
    wget %MYSQL_SERVER_URL% -O %TMP_DIR%\mariadb.zip
)
echo done

echo download PHP interpreter
IF NOT EXIST %TMP_DIR%\php.zip (
    wget %PHP_SERVER_URL% -O %TMP_DIR%\php.zip
)
echo done

echo download files - done

rem unpack archives
echo unpack archives - start
echo unpack Apache HTTP Server
7z x %TMP_DIR%\httpd.zip -o%USR_DIR%
rename %USR_DIR%\Apache24 httpd
echo done

echo unpack MySQL Server
7z x %TMP_DIR%\mariadb.zip -o%USR_DIR%
rename %USR_DIR%\mariadb-10.6.5-winx64 mariadb
echo done

echo unpack PHP interpreter
7z x %TMP_DIR%\php.zip -o%USR_DIR%\php
echo done
echo unpack archives - done

rem config servers
echo config servers - start
copy %CONFIG_DIR%\httpd.conf %USR_DIR%\httpd\conf\httpd.conf
copy %CONFIG_DIR%\my.ini %USR_DIR%\mariadb\my.ini
copy %CONFIG_DIR%\php.ini %USR_DIR%\php\php.ini
echo config servers - done

rem prepare for start
echo prepare for start - start
echo init database
%USR_DIR%\mariadb\bin\mariadb-install-db.exe --password=%MYSQL_PASSWORD%
echo done
echo create start script
copy %CONFIG_DIR%\start.cmd %SERVER_DIR%
copy %CONFIG_DIR%\stop.cmd %SERVER_DIR%
copy %CONFIG_DIR%\index.php %WWW_DIR%
echo done

echo prepare for start - done
echo all jobs done
