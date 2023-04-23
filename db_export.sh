#!/bin/bash

docker compose exec db mysqldump -pmovabletype --opt --add-drop-database --databases movabletype > backup.sql
