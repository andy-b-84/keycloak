#!/usr/bin/env sh

until nc -z postgres 5432; do
    echo Waiting for PostgreSQL; sleep 5;
done

echo PostgreSQL has bound its port

/opt/jboss/docker-entrypoint.sh -b 0.0.0.0
