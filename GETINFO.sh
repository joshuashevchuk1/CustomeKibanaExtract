function getInfo {
    DETAIL=`find -name "SYSTEM-DETAIL-LOG*"`
    GETTER=FALSE
    export MODE=
    export VERSION=
    export SUBMODEL=
    export LOG_HOSTNAME=
    export LOG_TYPE=unknown
    DETAIL=`find -name 'SYSTEM-DETAIL-LOG*'`
}
