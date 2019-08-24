rm -rf $1Paths.yaml $1Model.yaml $1.yaml
./processModelAndISO.sh $1
#./processModel.sh $1
./processPathConfig.sh $1
cat $1Paths.yaml $1Model.yaml>>$1.yaml
echo "Generated Final YAML $1.yaml :) :)"
