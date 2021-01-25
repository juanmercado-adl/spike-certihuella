# spike-certihuella

Diagrama esquematico de la PoC:

![Diagrama esquematico de la PoC](doc/assets/diagrama-despliegue-certihuella.png)

Descripción: 

*Carga/Sincronización*

1. Un agente sube un archivo al bucket de entrada, de este se replica al bucket de operaciones (la configuración de la replicación y la ruta se hace a través de terraform)

2. Cuando el archivo se replica, dispara un evento asincrono hacia la lambda "process file".

3. La lambda "process file" interpreta el archivo y realiza una sincronización de la información con la base de datos (tabla en dynamoDB).

*Consulta/Validación*

1. Un agente valida la información de un cliente a través de un API REST. 

2. API Gateway dispara un evento sincrono hacia la lambda "client validation"

3. La lambda "client validation" ejecuta una consulta hacia la tabla de dyanamo y retorna la respuesta al cliente.




Dudas: 

1. ¿Cuál va a hacer el ciclo de vida de los archivos subidos en el bucket de operaciones? (tiempo de retención, que pasa una vez se sincronice con la base de datos, los datos se encripatrán en este bucket) 
2. ¿En que ruta el agente de certihuella va a subir los archivos? ¿Qué formato tienen los archivos (.csv, .xlsx, .xls)?
3. ¿Cuantos elementos tienen los archivos en promedio, que columnas tiene?
4. ¿Es posible que lleguen datos repetidos en los archivos, datos ya registrados? ¿hay algún mecanismo de actualización de los datos en la base de datos? 
5. ¿Los datos en la base de datos deben estar encriptados (Es información sensible) ya vienen encriptados?
6. ¿Cuál va a ser el mecanismo de seguridad para el endpoint del servicio de validación (OAuth con JWT por ejemplo)?
7. ¿Bajo que metricas se va a medir el rendimiento del sistema (peticiones/segundo para consulta) (archivos procesados/hora, minuto, saturación uso de recursos replicas)?
8. ¿Qué estrategía se va a manejar para el manejo de erroes de carga, sincronización de datos, erroes de la api? 
9. ¿Comó es el request y el response del API Client Validation?


Las lambdas son construidas utilizando Java y el framewor de inyección de dependencias [Google Guice](https://github.com/google/guice/wiki/Motivation)

Para realizar las pruebas locales:

1. Garantice que tiene instalado [AWS SAM](https://medium.com/@altaf.shaikh2963/how-to-build-run-and-debug-aws-lambda-function-locally-using-aws-sam-cli-bfaea8ff9cb7)

```sh
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaClientValidation" --event - --debug --profile "default"  
echo '{"lambdaName": "value1" }' | sam local invoke "lambdaProcessFile" --event - --debug --profile "default"  


sam local invoke "lambdaProcessFile" --event test/s3-event.json --debug --profile "default"

#subir ejeuctable client validation
aws s3 cp .\build\distributions\lambda-client-validation-1.15-SNAPSHOT.zip s3://vikingos-validate-client-repo/lambda-client-validation-1.15-SNAPSHOT.zip
```


Cambios necesarios para el repo de infraestructura para agregar un nuevo bucket s3:

1. Crear el bucket de operación
En el archivo del enviroment/s3.tf
```js
resource "aws_s3_bucket" "s3_bucket_certihuella" {
  bucket = "${var.stack_id}-certihuella"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    local.common_tags,
    {
      "Name"        = "${var.stack_id}-fcertihuella"
      "Environment" = var.stack_id
    },
  )
}
```
2. Crear directorio dentro del bucket de entrada 
```js
resource "aws_s3_bucket_object" "s3_bank_landing_in_certihuella_object" {
  key        = "celulas-adl/certihuella/" /*Se esta pendiente de la definición del nombre de esta ruta*/
  bucket     = aws_s3_bucket.s3_bank_landing_in.id
  acl        = "private"
  source     = "/dev/null"
  tags       = local.common_tags
  depends_on = [aws_s3_bucket_object.s3_bank_landing_in_celulas_adl_object]
}
```

3. Crear regla de replicación
En el archivo _locals.tf_, se agrega a la lista de *bpop_s3_replication_configuration_items*
```js
{
    rule_id                = "certihuella"
    priority               = "2"
    rule_prefix            = "celulas-adl/certihuella"
    destination_account_id = var.certihuella_account_id
    destination_bucket     = var.s3_bank_certihuella_in_arn /*arn del bucket creado*/
}
```
Nota se deben crear las variables indicadas en el archivo _variables.tf_

