#!/usr/bin/env bash
export PGPASSWORD=$POSTGRES_PASSWORD

COMMAND=$1
shift

case $COMMAND in
    psql)
        psql -h $POSTGRESQL_PORT_5432_TCP_ADDR -p $POSTGRESQL_PORT_5432_TCP_PORT -U $POSTGRES_USER $POSTGRES_DB $@
        ;;
    pg_dump)
        pg_dump -h $POSTGRESQL_PORT_5432_TCP_ADDR -p $POSTGRESQL_PORT_5432_TCP_PORT -U $POSTGRES_USER -d $POSTGRES_DB $@
        ;;
    *)
        echo "Known commands are: psql, pg_dump"
        ;;
esac
