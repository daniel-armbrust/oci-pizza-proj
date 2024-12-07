# O Serviço de Redes do OCI

Antes de iniciar a criação de qualquer recurso no OCI, é necessário configurar uma rede. Isso se deve ao fato de que a maioria dos serviços disponíveis no OCI, assim como os serviços que serão utilizados pela aplicação OCI Pizza, dependem de uma rede adequadamente configurada e pronta para uso.

>_**__NOTA:__** Um recurso, no contexto de computação em nuvem e tecnologia da informação, refere-se a qualquer componente ou serviço que pode ser utilizado para construir, implementar e gerenciar aplicações e sistemas._

O [Serviço de Redes](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/landing.htm) do OCI disponibiliza versões virtuais para a maioria dos componentes de redes tradicionais que conhecemos. A configuração da rede é um pré-requisito essencial para o funcionamento de qualquer aplicação na nuvem.

Toda documentação do serviço de redes para o OCI CLI, pode ser consultada neste link: [Networking Service CLI](https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.50.2/oci_cli_docs/cmdref/network.html).

A topologia de rede a seguir será adotada para a aplicação OCI Pizza:

![alt_text](./imgs/network-topology-1.png "Network Topology 1")

## Descrição dos Componentes da Rede

Abaixo, apresentamos a descrição dos componentes de rede que serão utilizados pela aplicação OCI Pizza.

- **[VCN (Virtual Cloud Network)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/VCNs.htm)**
  - Trata-se de uma rede virtual privada criada dentro de uma região.
  - Após a criação e configuração da VCN, é possível criar sub-redes, máquinas virtuais, bancos de dados e outros recursos.

- **Subnet**
  - É a divisão de uma VCN em partes menores, conhecidas como sub-redes.
  - Cada sub-rede consiste em um intervalo contíguo de endereços IP que não se sobrepõe aos intervalos de outras sub-redes da VCN.
  - Uma sub-rede pode ser _pública_ ou _privada_. Uma sub-rede pública permite expor um recurso à internet por meio de um IP público, enquanto uma sub-rede privada acessa a internet apenas por meio da técnica de NAT (Network Address Translation).
  - Ao criar uma sub-rede, três endereços IP são automaticamente reservados. Esses endereços são: 
    - Endereço de rede
    - Endereço de Broadcast 
    - Endereço do Default Gateway (roteador da sub-rede)

- **[Route Table](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingroutetables.htm)**
  - Contém as regras de roteamento para direcionar o tráfego de rede ao próximo salto (next-hop).
  - Sub-redes dentro da mesma VCN podem se comunicar sem a necessidade de regras de roteamento. No entanto, é possível definir esse tipo de regra, caso desejado.

- **[Security List](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/securitylists.htm)**
  - É o firewall virtual que protege a sub-rede.
  - Todo o tráfego que entra e sai da sub-rede é verificado pela sua Security List.
  - Por padrão, toda a comunicação é bloqueada pela Security List. No entanto, é possível permitir o tráfego de rede com base em protocolos e portas, tanto para IPv4 quanto para IPv6.

- **[VNIC (Virtual Network Interface Card)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingVNICs.htm)**
  - O termo vem de NIC (network interface card). É uma interface de rede virtual.
  - Toda VNIC obrigatóriamente reside em uma sub-rede.
  - Uma VNIC pode ter até 31 endereços IPv4 privados, um endereço IPv4 público opcional para cada IP privado e até 32 endereços IPv6 opcionais.

- **[DHCP Options](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDHCP.htm)**
  - É o serviço DHCP da sub-rede.

- **Gateways de Comunicação**

  - [Internet Gateway (IGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingIGs.htm#Internet_Gateway)
    - Permite a comunicação direta proveniente da internet. Para isso, é necessário que o recurso possua um IP público. 

  - [NAT Gateway (NGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/NATgateway.htm)
    - Permite que recursos sem um endereço IP público acessem a internet, possibilitando a comunicação enquanto evita a exposição direta desses recursos na rede pública.

  - [Service Gateway (SGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm#overview)
    - Permite que recursos de uma sub-rede se comuniquem diretamente com os serviços do OCI por meio da [Oracle Services Network (OSN)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm#oracle-services), sem a necessidade de utilizar a internet.

  - [Dynamic Routing Gateway (DRG)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm)
    - É um roteador virtual.
    - Permite conectividade entre as suas VCNs, tanto dentro de uma mesma região quanto entre regiões diferentes, além de permitir a conexão com o ambiente on-premises por meio de [VPN](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingIPsec.htm) ou [FastConnect](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/fastconnect.htm).

A seguir, será criada toda a rede da região _Brazil East (São Paulo)_. Para a rede da região _Brazil Southeast (Vinhedo)_, os comandos permanecem os mesmos, com a modificação apenas de alguns valores correspondentes à região, como endereços IP e nomes dos recursos. Por essa razão, não serão apresentados aqui. 

>_**__NOTA:__** Todos os comandos utilizados para a criação da VCN e dos demais recursos de rede na região Brazil East (São Paulo) estão no script [scripts/network-saopaulo.sh](../scripts/network-saopaulo.sh). Para a região Brazil Southeast (Vinhedo), os comandos podem ser encontrados no script [scripts/network-vinhedo.sh](../scripts/network-vinhedo.sh)._

## VCN (vcn-saopaulo)

Iniciaremos com a criação da VCN:

- **Sao Paulo, Brazil (sa-saopaulo-1):**
  - Nome: vcn-saopaulo
  - Bloco CIDR: 172.16.0.0/16

```
$ oci --region "sa-saopaulo-1" network vcn create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --cidr-blocks '["172.16.0.0/16"]' \
> --display-name "vcn-saopaulo" \
> --dns-label "vcnsaopaulo" \
> --wait-for-state AVAILABLE
```

O comando abaixo retorna o OCID da VCN "vcn-saopaulo" que foi criada, pois os recursos subsequentes necessitam dessa informação:

```
$ oci --region "sa-saopaulo-1" network vcn list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --display-name "vcn-saopaulo" \
> --query 'data[].id'
[
  "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

## Gateways de Comunicação

Os **Gateways de Comunicação** permitem que os recursos dentro de uma sub-rede no OCI se comuniquem com qualquer outro recurso externo. Esses recursos externos podem incluir a Internet, a rede de serviços da Oracle [(Oracle Services Network (OSN)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm#oracle-services) ou ambientes on-premises.

Todo gateway de comunicação que for criado, com exceção do DRG, requer uma VCN que já tenha sido previamente criada. Essa dependência pode ser observada por meio do parâmetro _--vcn-id_ nos comandos a seguir.

### Internet Gateway (igw)

```
$ oci --region "sa-saopaulo-1" network internet-gateway create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --is-enabled "true" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "igw" \
> --wait-for-state "AVAILABLE"
```

```
$ oci --region "sa-saopaulo-1" network internet-gateway list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --display-name "igw" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --lifecycle-state "AVAILABLE" \
> --query 'data[].id'
[
  "ocid1.internetgateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

### NAT Gateway (ngw)

```
$ oci --region "sa-saopaulo-1" network nat-gateway create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --block-traffic "false" \
> --display-name "ngw" \
> --wait-for-state "AVAILABLE"
```

```
$ oci --region "sa-saopaulo-1" network nat-gateway list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --display-name "ngw" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --lifecycle-state "AVAILABLE" \
> --query 'data[].id'
[
  "ocid1.natgateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

### Service Gateway (sgw)

A [Oracle Services Network (OSN)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm) é uma rede conceitual dentro do OCI dedicada exclusivamente aos serviços da Oracle. Esses serviços possuem endereços IP públicos que geralmente são acessados pela internet.

A função do Service Gateway é possibilitar que seus recursos dentro da VCN acessem diretamente e de forma privada esses serviços. Além disso, o uso de um Service Gateway evita a cobrança de **Outbound Data Transfer** ao acessar esses serviços tanto a partir da VCN quanto do ambiente on-premises.

>_**__NOTA:__** O preço do Outbound Data Transfer para a sua região pode ser consultado no link: [Cloud Networking Pricing](https://www.oracle.com/cloud/networking/pricing/)_

O Service Gateway utiliza o conceito de _Service CIDR label_ que é uma string que representa os endereços públicos dos serviços Oracle em uma região. Usar uma string que representa os endereços dos serviços é mais prático do que inserir os IPs manualmente.

Para listar os _Service CIDR labels_ de uma região, utilize o comando a seguir:

```
$ oci --region "sa-saopaulo-1" network service list --all
{
  "data": [
    {
      "cidr-block": "all-gru-services-in-oracle-services-network",
      "description": "All GRU Services In Oracle Services Network",
      "id": "ocid1.service.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc",
      "name": "All GRU Services In Oracle Services Network"
    },
    {
      "cidr-block": "oci-gru-objectstorage",
      "description": "OCI GRU Object Storage",
      "id": "ocid1.service.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbcccddddddd",
      "name": "OCI GRU Object Storage"
    }
  ]
}
```

Foram listados dois _Service CIDR labels_ para a região "sa-saopaul-1":

- **all-gru-services-in-oracle-services-network**
  - Esse label representa todos os serviços disponíveis na região, incluindo servidores para atualização do Oracle Linux (yum update), Object Storage, entre outros.

- **oci-gru-objectstorage**
  - Esse label representa somente os IPs do serviço Object Storage.

Para criar o Service Gateway que utilizará todos os serviços _(all-gru-services-in-oracle-services-network)_, utilize o comando abaixo:

```
$ oci --region "sa-saopaulo-1" network service-gateway create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --services "[
>     {
>         \"serviceId\": \"ocid1.service.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\",
>         \"serviceName\": \"All GRU Services In Oracle Services Network\"
>     }
> ]" \
> --display-name "sgw" \
> --wait-for-state "AVAILABLE"
```

```
$ oci --region "sa-saopaulo-1" network service-gateway list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --lifecycle-state "AVAILABLE" \
> --query 'data[].id'
[
  "ocid1.servicegateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

## Route Table (rtb_subnpub e rtb_subnprv)

A VCN utiliza a [Route Table](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingroutetables.htm) para direcionar o tráfego de rede para fora da VCN. Uma Route Table é composta por uma ou mais _Route Rules_, que especificam qual gateway receberá um determinado tráfego de rede _(próximo salto ou next hop)_.

Em resumo, a Route Table contém um conjunto de regras que definem como os dados originados em uma sub-rede devem ser encaminhados, por meio de um gateway de comunicação, para uma rede distinta. O papel do Gateway de Comunicação pode ser visto como uma "ponte" entre essas duas redes diferentes.

 >_**__NOTA:__** A Route Table utilizada por uma subnet é diferente da Route Table utilizada pelo DRG. Aqui, será criada e configurada uma Route Table para a subnet._

A Route Table da sub-rede pública _(rtb\_subnpub)_ incluirá uma Route Rule que utilizará o [Internet Gateway (IGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingIGs.htm#Internet_Gateway), permitindo que os recursos dessa sub-rede recebam tráfego proveniente da Internet.

```
$ oci --region "sa-saopaulo-1" network route-table create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "rtb_subnpub" \
> --route-rules "[
>     {
>         \"destination\": \"0.0.0.0/0\",
>         \"destinationType\": \"CIDR_BLOCK\",
>         \"networkEntityId\": \"ocid1.internetgateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\"
>     }
> ]" \
> --wait-for-state "AVAILABLE"
```

A Route Table da sub-rede privada _(rtb\_subnprv)_ incluirá uma Route Rule que utilizará o [NAT Gateway (NGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/NATgateway.htm) para permitir que os recursos acessem a Internet sem receber tráfego direto. Além disso, haverá uma Route Rule que utilizará o [Service Gateway (SGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm#overview).

```
$ oci --region "sa-saopaulo-1" network route-table create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "rtb_subnprv" \
> --route-rules "[
>     {
>         \"destination\": \"0.0.0.0/0\",
>         \"destinationType\": \"CIDR_BLOCK\",
>         \"networkEntityId\": \"ocid1.internetgateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\"
>     },
>     {
>         \"destination\": \"all-gru-services-in-oracle-services-network\",
>         \"destinationType\": \"SERVICE_CIDR_BLOCK\",
>         \"networkEntityId\": \"ocid1.servicegateway.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\"
>     }
> ]" \
> --wait-for-state "AVAILABLE"
```

## Security List (seclist_subnpub e seclist_subnprv)



## DHCP Options (dhcp-options)

## Subnet (subnpub e subnprv)
