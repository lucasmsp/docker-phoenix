#!/usr/bin/env bash

# to be able to run hbase shell
apk update && apk add jruby asciidoctor

HBASE_SITE="/opt/hbase/conf/hbase-site.xml"

addConfig () {

    if [ $# -ne 3 ]; then
        echo "There should be 3 arguments to addConfig: <file-to-modify.xml>, <property>, <value>"
        echo "Given: $@"
        exit 1
    fi

    xmlstarlet ed -L -s "/configuration" -t elem -n propertyTMP -v "" \
     -s "/configuration/propertyTMP" -t elem -n name -v $2 \
     -s "/configuration/propertyTMP" -t elem -n value -v $3 \
     -r "/configuration/propertyTMP" -v "property" \
     $1
}

# Phoenix/HBase parameters:

addConfig $HBASE_SITE "hbase.regionserver.wal.codec" "org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec"
addConfig $HBASE_SITE "hbase.region.server.rpc.scheduler.factory.class" "org.apache.hadoop.hbase.ipc.PhoenixRpcSchedulerFactory"
addConfig $HBASE_SITE "hbase.rpc.controllerfactory.class" "org.apache.hadoop.hbase.ipc.controller.ServerRpcControllerFactory"
addConfig $HBASE_SITE "hbase.unsafe.stream.capability.enforce" "false"
addConfig $HBASE_SITE "data.tx.snapshot.dir" "/tmp/tephra/snapshots"
addConfig $HBASE_SITE "data.tx.timeout" "60"
addConfig $HBASE_SITE "phoenix.transactions.enabled" true
#addConfig $HBASE_SITE "phoenix.schema.isNamespaceMappingEnabled" true
addConfig $HBASE_SITE "hbase.regionserver.thrift.framed" true
addConfig $HBASE_SITE "hbase.regionserver.thrift.compact" true

#addConfig $HBASE_SITE "phoenix.connection.autoCommit" true

#addConfig $HBASE_SITE "phoenix.mutate.batchSize" "500"
#addConfig $HBASE_SITE "phoenix.mutate.batchSize" "209715200"
#addConfig $HBASE_SITE "phoenix.upsert.batch.size" "500"


export HBASE_CONF_DIR=/opt/hbase/conf
export HBASE_CP=/opt/hbase/lib
export HBASE_HOME=/opt/hbase

function clean_up {
    /opt/hbase/bin/stop-hbase.sh
    /opt/phoenix-server/bin/queryserver.py stop
    /opt/hbase/bin/tephra stop

    exit
}

trap clean_up SIGINT SIGTERM

/opt/hbase/bin/start-hbase.sh &
/opt/phoenix-server/bin/queryserver.py start &
/opt/hbase/bin/tephra start &

while true; do sleep 1; done