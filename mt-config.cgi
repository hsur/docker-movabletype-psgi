CGIPath        http://localhost:8000/mt/
StaticWebPath  /mt-static/
StaticFilePath /var/www/html/mt-static
BaseSitePath   /var/www/html

ObjectDriver DBI::mysql
Database movabletype
DBUser movabletype
DBPassword movabletype
DBHost db

DefaultLanguage ja

PIDFilePath /var/run/mt.pid
CGIMaxUpload 51200000
