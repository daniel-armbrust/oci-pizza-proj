# Reserva de Endereço IP Público

Um endereço IP público é um endereço que pode ser acessado pela internet. Para que um recurso seja acessível a partir da internet, ele deve estar localizado em uma sub-rede pública, equipada com um Internet Gateway, e deve possuir um endereço IP público.

>_**__NOTA:__** Todos os comandos utilizados neste capítulo estão disponíveis nos scripts [scripts/chapter-3/pubip-reserved-saopaulo.sh](../scripts/chapter-3/pubip-reserved-saopaulo.sh) e [scripts/chapter-3/network-vinhedo.sh](../scripts/chapter-3/network-vinhedo.sh)._

Qualquer recurso criado e que utiliza um endereço IP público no OCI, está sujeito a usar um destes dois tipos:

- **IP Público Efêmero (Ephemeral)**

    - Temporário e existe apenas durante a vida útil do recurso.
    - Se o recurso for excluído, o endereço IP público associado também será removido, e não será possível reutilizá-lo.

- **IP Público Reservado (Reserved)**

    - Persistênte e não está vinculado ao tempo de vida de um recurso.
    - Se o recurso for excluído, o endereço IP público associado não será removido.

Ao [reservar um endereço IP público](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingpublicIPs.htm#overview), ele passa a ser de "posse" do seu tenancy, permitindo que você o utilize em qualquer recurso que desejar.  

Para a aplicação OCI Pizza, será reservado um endereço IP público em cada região para os respectivos Load Balancers, uma vez que eles são responsáveis por receber o tráfego de rede diretamente da internet. Caso um Load Balancer seja acidentalmente excluído, é possível criar um novo Load Balancer e atribuir a ele o endereço IP previamente reservado, evitando assim a necessidade de reconfigurar o DNS público da aplicação.

Para reservar o endereço IP público, utilize o seguinte comando:

```
$ oci --region "sa-saopaulo-1" network public-ip create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --lifetime "RESERVED" \
> --display-name "pubip-lb-saopaulo" \
> --wait-for-state "AVAILABLE"
```

Para verificar qual foi o endereço IP que o OCI reservou, utilize o seguinte comando:

```
$ oci --region "sa-saopaulo-1" network public-ip list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --lifetime "RESERVED" \
> --scope "REGION" \
> --query data[].\"ip-address\" \
> --all
[
  "137.131.197.197"
]
```

>_**__NOTA:__** Se mais de um endereço IP tiver sido reservado, o comando acima retornará mais de um._