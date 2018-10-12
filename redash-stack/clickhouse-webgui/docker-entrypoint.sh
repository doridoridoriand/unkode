#!/bin/bash

echo ${CLICK_HOUSE_HOST}
echo ${CLICK_HOUSE_PORT}

/usr/local/bundle/bin/clickhouse server http://${CLICK_HOUSE_HOST}:${CLICK_HOUSE_PORT}
