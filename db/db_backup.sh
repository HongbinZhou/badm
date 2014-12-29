#!/bin/sh

suffix=".$(date +%Y%m%d.bak)"

cp development.sqlite3{,$suffix}
