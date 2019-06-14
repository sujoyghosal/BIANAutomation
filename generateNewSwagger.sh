rm -rf $1Paths.yaml $1Model.yaml $1.yaml
part.sh $1
processNewPathConfig.sh $1
cat $1Paths.yaml $1Model.yaml >>$1.yaml
echo "Generated Final YAML file $1.yaml :):)"
