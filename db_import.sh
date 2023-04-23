#!/bin/bash

docker compose exec db -T mysql -pmovabletype movabletype < backup.sql
