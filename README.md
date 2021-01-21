# spike-certihuella

Diagrama esquematico de la PoC:

![Diagrama esquematico de la PoC](doc/assets/diagrama-despliegue-certihuella.png)

Descripción: 


Las lambdas son construidas utilizando Java y el framewor de inyección de dependencias [Google Guice](https://github.com/google/guice/wiki/Motivation)

Para realizar las pruebas locales:

1. Garantice que tiene instalado [AWS SAM](https://medium.com/@altaf.shaikh2963/how-to-build-run-and-debug-aws-lambda-function-locally-using-aws-sam-cli-bfaea8ff9cb7)

```sh
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaClientValidation" --event - --debug --profile "default"  
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaProcessFile" --event - --debug --profile "default"  
```