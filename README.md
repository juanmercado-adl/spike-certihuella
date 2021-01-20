# spike-certihuella

```sh
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaClientValidation" --event - --debug --profile "default"  
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaProcessFile" --event - --debug --profile "default"  
```