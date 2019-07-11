#Path Generation - Execute as "processPathConfig.sh [sd name e.g. CardClearing]" 
readConfig="false"
input=$1"PathConfig"
output=$1"Paths.yaml"
mcr=
cat $input|sed -e $'s/\t/|/g' -e $'s/"//g'>p
while read line
do    
    if  [[ $line == sd=* ]] ;
    then
        sdb=`echo $line|cut -f2 -d"="`
        sd=`echo $sdb|sed 's/ //g'`
        echo "swagger: '2.0'">$output
        echo "info:">>$output
        echo " version: '1.0.0'">>$output
        echo " title: 'Service Domain - $sdb'">>$output
        echo " description: 'Description'">>$output
        echo "host: virtserver.swaggerhub.com">>$output
        basepath=`echo $sdb|sed 's/ /-/g'|tr '[:upper:]' '[:lower:]'`>>$output
        echo "basePath: /BIAN/sd-$basepath/1.0.0">>$output
        echo "schemes:">>$output
        echo " - https">>$output
        echo "paths:">>$output
    fi
    if  [[ $line == sdpath=* ]] ;
    then
        sdpath=`echo $line|cut -f2 -d"="`
    fi
    if  [[ $line == crpath=* ]] ;
    then
        crpath=`echo $line|cut -f2 -d"="`
    fi
    if  [[ $line == crr=* ]] ;
    then
        crr=`echo $line|cut -f2 -d"="`
    fi
    if  [[ $line == mcr=* ]] ;
    then
        mcr=`echo $line|cut -f2 -d"="`
    fi
    if  [[ $line == bqs=* ]] ;
    then
        bq=`echo $line|cut -f2 -d"="`
        declare -a bqs=($bq)
    fi
    if  [[ $line == CONFIG* ]] ;
    then
        echo "Starting to read configs"
        readConfig="true";
        continue;
    fi
    if [ $readConfig == "true" ]
    then
        line=`echo $line|sed 's/    /|/g'`
        cr=`echo $line|cut -f1 -d"|" |tr '[:upper:]' '[:lower:]'`
#        bcr=`echo ${cr:0:1} | tr  '[a-z]' '[A-Z]'`${cr:1} #first character capital letter
        bcr=`echo $line|cut -f1 -d"|"|sed 's/ //g'`
        actionRaw=`echo $line|cut -f2 -d"|"`
        desc=`echo $line|cut -f3 -d"|"|sed 's/[:""]/ /g'`
        extOp=`echo $line|cut -f4 -d"|"`
        extApi=`echo $line|cut -f5 -d"|"`
        summary=`echo $line|cut -f7 -d"|"|sed 's/[:]/ /g'`
        z=`echo $actionRaw | tr '[:upper:]' '[:lower:]'`
        if [ -z "$extOp" -a  -z "$extApi" ]; then
            echo "Processing $cr $z - skipping"
            continue
        fi
        echo "Creating Path Definitions for $cr $z ..."
        case $z in
            initiate|create|activate|register|evaluate|provide)
                if [ $z == "initiate" ]
                then
                    action="initiation"
                    tag="initiate"
                fi
                if [ $z == "create" ]
                then
                    action="creation"
                    tag="create"
                fi
                if [ $z == "activate" ]
                then
                    action="activation"
                    tag="activate"
                fi
                if [ $z == "register" ]
                then
                    action="registration"
                    tag="register"
                fi
                if [ $z == "evaluate" ]
                then
                    action="evaluation"
                    tag="evaluate"
                fi
                if [ $z == "provide" ]
                then
                    action="provision"
                    tag="provide"
                fi
                if [ $z == "authorize" ]
                then
                    action="authorization"
                    tag="authorize"
                fi
                if [ ! -z "$extOp" -a "$extOp" != " " ]; then #BQ Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/$cr/$action:">>$output
                    echo "    post:">>$output
                    echo "      tags:">>$output
                    echo "      - $tag">>$output
                    echo "      operationId: $extOp">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/BQ$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        201:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    foo=`echo ${cr:0:1} | tr  '[a-z]' '[A-Z]'`${cr:1}
                    echo "            \$ref: '#/definitions/BQ$bcr$actionRaw"OutputModel\'>>$output
                else #CR Level
                    echo "  /$sdpath/$crpath/$action:">>$output
                    echo "    post:">>$output
                    echo "      tags:">>$output
                    echo "      - $tag">>$output
                    echo "      operationId: $extApi">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/CR$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        201:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/CR$bcr$actionRaw"OutputModel\'>>$output
                fi
                ;;
            record)
                if [ ! -z "$extOp" -a "$extOp" != " " ]; then #BQ Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/$cr/{bq-reference-id}/recording:">>$output
                    echo "    post:">>$output
                    echo "      tags:">>$output
                    echo "      - record">>$output
                    echo "      operationId: $extOp">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - name: bq-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: "$bcr BQ Reference Id"">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        201:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    foo=`echo ${cr:0:1} | tr  '[a-z]' '[A-Z]'`${cr:1}
                    echo "            \$ref: '#/definitions/$actionRaw"OutputModel\'>>$output
                else #CR Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/recording:">>$output
                    echo "    post:">>$output
                    echo "      tags:">>$output
                    echo "      - record">>$output
                    echo "      operationId: $extApi">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        201:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/$actionRaw"OutputModel\'>>$output
                fi
                ;;
            update)
                if [ ! -z "$extOp" -a "$extOp" != " " ]; then #BQ Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/$cr/{bq-reference-id}/update:">>$output
                    echo "    put:">>$output
                    echo "      tags:">>$output
                    echo "      - update">>$output
                    echo "      operationId: $extOp">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - name: bq-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: "$bcr BQ Reference Id"">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/BQ$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        200:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/BQ$bcr$actionRaw"OutputModel\'>>$output
                else #CR Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/update:">>$output
                    echo "    put:">>$output
                    echo "      tags:">>$output
                    echo "      - update">>$output
                    echo "      operationId: $extApi">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/CR$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        200:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/CR$bcr$actionRaw"OutputModel\'>>$output
                fi
                ;;
            execute|request|control|exchange|capture|grant)
                if [ "$z" == "execute" ]
                then
                    action="execution"
                    tag="execute"
                fi
                if [ "$z" == "request" ]
                then
                    action="requisition"
                    tag="request"
                fi
                if [ "$z" == "control" ]
                then
                    action="control"
                    tag="control"
                fi
                if [ "$z" == "exchange" ]
                then
                    action="exchange"
                    tag="exchange"
                fi
                if [ "$z" == "capture" ]
                then
                    action="capture"
                    tag="capture"
                fi
                if [ "$z" == "grant" ]
                then
                    action="grant"
                    tag="grant"
                fi
                if [ ! -z "$extOp" -a "$extOp" != " " ]; then #BQ Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/$cr/{bq-reference-id}/$action:">>$output
                    echo "    put:">>$output
                    echo "      tags:">>$output
                    echo "      - $tag">>$output
                    verb="Update"
                    echo "      operationId: $extOp$verb">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - name: bq-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: "$bcr BQ Reference Id"">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr request payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/BQ$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        200:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/BQ$bcr$actionRaw"OutputModel\'>>$output
                else #CR Level
                    echo "  /$sdpath/$crpath/{cr-reference-id}/$action:">>$output
                    echo "    put:">>$output
                    echo "      tags:">>$output
                    echo "      - $tag">>$output
                    verb="Update"
                    echo "      operationId: $extApi$verb">>$output
                    echo "      summary: $summary">>$output
                    echo "      description: $desc">>$output
                    echo "      produces:">>$output
                    echo "      - application/json">>$output
                    echo "      parameters:">>$output
                    echo "      - name: cr-reference-id">>$output
                    echo "        in: path">>$output
                    echo "        description: $crr">>$output
                    echo "        required: true">>$output
                    echo "        type: string">>$output
                    echo "      - in: body">>$output
                    echo "        name: body">>$output
                    echo "        required: true">>$output
                    echo "        description: $bcr Request Payload">>$output
                    echo "        schema:">>$output
                    echo "          \$ref: '#/definitions/CR$bcr$actionRaw"InputModel\'>>$output
                    echo "      responses:">>$output
                    echo "        200:">>$output
                    echo "          description: Successful $summary">>$output
                    echo "          schema:">>$output
                    echo "            \$ref: '#/definitions/CR$bcr$actionRaw"OutputModel\'>>$output
                fi
                ;;
            *)
                ;;
        esac
    fi
done<p
## Add Standard Retrieve Operations
echo "  /$sdpath/$crpath:">>$output
echo "    get:">>$output
echo "      tags:">>$output
echo "      - retrieve">>$output
echo "      operationId: Retrieve$sd"ReferenceIds>>$output
echo "      summary: Retrieve CR Ids">>$output
echo "      produces:">>$output
echo "      - application/json">>$output
echo "      parameters:">>$output
echo "      - name : collection-filter">>$output
echo "        in: query">>$output
echo "        description: Filter to refine the result set. ex- ">>$output
echo "        required: false">>$output
echo "        type: string">>$output
echo "      responses:">>$output
echo "        200:">>$output
echo "          description: Successful">>$output
echo "          schema:">>$output
echo "            type: array">>$output
echo "            items:">>$output
echo "              type: string">>$output
echo "            example: ['ID726464', 'ID7264642']">>$output
## Add Standard Retrieve Operations
echo "  /$sdpath/$crpath/behavior-qualifiers/:">>$output
echo "    get:">>$output
echo "      tags:">>$output
echo "      - retrieve">>$output
echo "      operationId: Retrieve$sd"BehaviorQualifiers>>$output
echo "      summary: Retrieve BQ names">>$output
echo "      produces:">>$output
echo "      - application/json">>$output
echo "      responses:">>$output
echo "        200:">>$output
echo "          description: Successful">>$output
echo "          schema:">>$output
echo "            type: array">>$output
echo "            items:">>$output
echo "              type: string">>$output
for i in "${bqs[@]}"
do
    e=$e" '$i', "
done
echo "            example: [$e]">>$output
## Add Standard Retrieve Operations
echo "  /$sdpath/$crpath/{cr-reference-id}/{behavior-qualifier}/:">>$output
echo "    get:">>$output
echo "      tags:">>$output
echo "      - retrieve">>$output
echo "      operationId: Retrieve$sd"BehaviorQualifierReferenceIds>>$output
echo "      summary: Retrieve Behavior Qualifier Reference Ids">>$output
echo "      produces:">>$output
echo "      - application/json">>$output
echo "      parameters:">>$output
echo "      - name: cr-reference-id">>$output
echo "        in: path">>$output
echo "        description: $crr">>$output
echo "        required: true">>$output
echo "        type: string">>$output
echo "      - name : behavior-qualifier">>$output
echo "        in: path">>$output
echo "        description: Behavior Qualifier Name. ex- 'BQ1'">>$output
echo "        required: true">>$output
echo "        type: string">>$output
echo "      - name : collection-filter">>$output
echo "        in: query">>$output
echo "        description: Filter to refine the result set. ex-">>$output
echo "        required: false">>$output
echo "        type: string">>$output
echo "      responses:">>$output
echo "        200:">>$output
echo "          description: Successful">>$output
echo "          schema:">>$output
echo "            type: array">>$output
echo "            items:">>$output
echo "              type: string">>$output
echo "            example: ['BQID1', 'BQID2']">>$output
# CR Level Rertieve
echo "  /$sdpath/$crpath/{cr-reference-id}:">>$output
echo "    get:">>$output
echo "      tags:">>$output
echo "      - retrieve">>$output
echo "      operationId: retrieve$sd">>$output
echo "      summary: Retrieve a $sdb Record">>$output
echo "      description: Retrieve a $sdb Record">>$output
echo "      produces:">>$output
echo "      - application/json">>$output
echo "      parameters:">>$output
echo "      - name: cr-reference-id">>$output
echo "        in: path">>$output
echo "        description: $crr">>$output
echo "        required: true">>$output
echo "        type: string">>$output
echo "      - in: body">>$output
echo "        name: body">>$output
echo "        required: true">>$output
echo "        description: $sdb Request Payload">>$output
echo "        schema:">>$output
#echo "          \$ref: '#/definitions/CR$cr"RetrieveInputModel\'>>$output
echo "          \$ref: '#/definitions/CR`echo $sdb|sed 's/ //g'`"RetrieveInputModel\'>>$output
echo "      responses:">>$output
echo "        200:">>$output
echo "          description: Successfully Retrieved $sdb Report">>$output
echo "          schema:">>$output
#echo "            \$ref: '#/definitions/$1$sd"WithIdAndRoot\'>>$output
echo "            \$ref: '#/definitions/CR`echo $sdb|sed 's/ //g'`"RetrieveOutputModel\'>>$output
# Loop thru BQ Array and generate Retrieves at BQ Level
for i in "${bqs[@]}"
do
    z=`echo $i | tr '[:upper:]' '[:lower:]'`
    echo "  /$sdpath/$crpath/{cr-reference-id}/$z/{bq-reference-id}:">>$output
    echo "    get:">>$output
    echo "      tags:">>$output
    echo "      - retrieve">>$output
    echo "      operationId: retrieve$sd"$i>>$output
    echo "      summary: Retrieve a $sdb $i Record">>$output
    echo "      description: Retrieve a $sdb $i Record">>$output
    echo "      produces:">>$output
    echo "      - application/json">>$output
    echo "      parameters:">>$output
    echo "      - name: cr-reference-id">>$output
    echo "        in: path">>$output
    echo "        description: $crr">>$output
    echo "        required: true">>$output
    echo "        type: string">>$output
    echo "      - name: bq-reference-id">>$output
    echo "        in: path">>$output
    echo "        description: "$i BQ Reference Id"">>$output
    echo "        required: true">>$output
    echo "        type: string">>$output
    echo "      - in: body">>$output
    echo "        name: body">>$output
    echo "        required: true">>$output
#    echo "        description: $bcr Request Payload">>$output
    echo "        description: $sdb $i Request Payload">>$output
    echo "        schema:">>$output
    echo "          \$ref: '#/definitions/BQ`echo $i|sed 's/ //g'`"RetrieveInputModel\'>>$output
    echo "      responses:">>$output
    echo "        200:">>$output
    echo "          description: Successfully Retrieved $sdb $i Report">>$output
    echo "          schema:">>$output
    echo "            \$ref: '#/definitions/BQ`echo $i|sed 's/ //g'`"RetrieveOutputModel\'>>$output
done
rm -rf p
echo "Generated Path Definitions YAML File $output :)"