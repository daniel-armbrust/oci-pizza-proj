# Reserva de Endereço IP Público

Um endereço IP público é um endereço que pode ser acessado pela internet. Se um recurso precisa ser acessado de forma direta pela internet, é necessário que ele possua um endereço IP público.

Qualquer recurso criado e que utiliza um endereço IP público no OCI, está sujeito a usar um destes dois tipos:

- **IP Público Efêmero (Ephemeral)**

    - Temporário e existente somente durante o tempo de vida do recurso.
    - Se o recurso for excluído, o endereço IP público associado também será removido, e não será possível reutilizá-lo.

- **IP Público Reservado (Reserved)**

    - Persistênte e não está vinculado ao tempo de vida de um recurso.
    - Se o recurso for excluído, o endereço IP público associado não será removido.

Ao [reservar um endereço IP público](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingpublicIPs.htm#overview), ele passa a ser de "posse" do seu tenancy, permitindo que você o utilize em qualquer outro recurso que desejar. Essa é uma prática recomendada, pois assegura que o endereço IP permaneça fixo, facilitando as configurações de DNS e garantindo que o IP esteja reservado exclusivamente para o seu ambiente. 

Para a aplicação OCI Pizza, será reservado um endereço IP público em cada região para os respectivos Load Balancers, uma vez que eles são responsáveis por receber o tráfego de rede diretamente da internet. Caso um Load Balancer seja acidentalmente excluído, é possível criar um novo Load Balancer e atribuir a ele o endereço IP previamente reservado, evitando assim a necessidade de reconfigurar o DNS público da aplicação.

Para reservar o endereço IP público, utilize o seguinte comando:

```
$ oci network public-ip create \
    --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
    --lifetime "RESERVED" \
    --display-name "pubip-lb-saopaulo" \
    --wait-for-state "AVAILABLE"
```

Para verificar qual foi o endereço IP que o OCI reservou, utilize o seguinte comando:

```
$ oci network public-ip list \
    --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
    --lifetime "RESERVED" \
    --scope "REGION" \
    --query data[].\"ip-address\" \
    --all
[
  "137.131.197.197"
]
```

>_**__NOTA:__** Se mais de um endereço IP tiver sido reservado, o comando acima retornará mais de um._