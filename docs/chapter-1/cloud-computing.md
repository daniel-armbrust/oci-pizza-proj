# 1.1 - O que é Computação em Nuvem?

## Datacenter como Serviço

Algumas definições que motivaram a criação da Computação em Nuvem:

Cloud Provider v/s Cloud Consumer

## O que é Computação em Nuvem?

Computação em Nuvem ou Cloud Computing não é um conceito novo e é difícil definir seu significado em poucas palavras. É necessário compreender um conjunto de definições para entender de fato o que é a Computação em Nuvem.

Um documento que detalha os conceitos relacionados à definição de Computação em Nuvem é o ["The NIST Definition of Cloud Computing"](https://csrc.nist.gov/pubs/sp/800/145/final), publicado em setembro de 2011. Esse documento é amplamente reconhecido como uma referência essencial na área de Computação em Nuvem.

De acordo com o NIST, a Computação em Nuvem é um modelo que possibilita o acesso, por meio da Internet, a um conjunto de recursos computacionais (como rede, armazenamento, servidores e serviços) que podem ser rapidamente criados e liberados de maneira simples, sem a necessidade de intervenção humana, como, por exemplo, ligar para um helpdesk para solicitar a criação de um servidor.

O NIST também especifica que um provedor de Computação em Nuvem deve apresentar _cinco características essenciais_. Além disso, o usuário que consome os serviços deve ser capaz de implantar sua aplicação ou provisionar sua infraestrutura, utilizando um dos _três modelos de serviço_ disponíveis (IaaS, PaaS ou SaaS), escolhendo entre um dos _modelos de implementação_ (nuvem pública, privada, híbrida ou comunitária).

Iniciaremos com a descrição das _cinco características essenciais_ que todo provedor de nuvem deve obrigatóriamente ter para ser reconhecido como um verdadeiro provedor de serviços em nuvem. Em seguida, abordaremos os _três tipos de serviços disponíveis_ e, por fim, discutiremos os _quatro modelos de implantação_.

### Características Essenciais

Estas são as características essenciais que devem estar presentes quando se trata de Computação em Nuvem. Em essência, um provedor de serviços que oferece Computação em Nuvem deve, no mínimo, possuir as seguintes características essenciais:

#### 1. On-demand self-service (Serviço sob demanda)

Um usuário que consome serviços em nuvem pode criar servidores, redes, bancos de dados e outros recursos conforme sua necessidade, tudo isso por meio da rede, sem precisar de qualquer intervenção humana por parte do provedor de nuvem.

#### 2. Broad Network Access (Amplo Acesso à Rede)

Os recursos computacionais estão disponíveis por meio da rede e devem ser acessíveis através de mecanismos padronizados, permitindo seu uso em dispositivos como celulares, tablets, laptops e estações de trabalho.

A expressão _"mecanismos padronizados"_ refere-se a métodos, protocolos ou interfaces que são amplamente aceitos e utilizados na indústria, que garantem a comunicação e a operação eficaz entre diferentes sistemas e serviços. Nesse contexto, podemos citar o protocolo TCP/IP, que é universalmente adotado, padronizado por meio de documentos RFC (Request for Comments) e implementado pela maioria dos sistemas operacionais disponíveis. Em outras palavras, o uso do protocolo TCP/IP serve como um meio padronizado para criar ou acessar os recursos oferecidos pelo provedor de nuvem.

#### 3. Resource Pooling (Agrupamento de Recursos)

Os recursos computacionais de um provedor de nuvem são agrupados para atender a múltiplos clientes, que permanecem isolados uns dos outros, por meio de um modelo conhecido como _multi-tenant_ (multilocatário). Os diferentes recursos, tanto físicos quanto virtuais, são dinamicamente atribuídos e reatribuídos conforme a demanda do cliente. Geralmente, o cliente não tem controle ou conhecimento sobre a localização exata dos recursos fornecidos pelo provedor de nuvem. 

Por exemplo, no OCI ao escolher a região _"Brazil East (São Paulo)"_, o usuário é informado de que seus recursos serão criados no Brasil, especificamente em alguma das cidades da grande _São Paulo_. No entanto, não é possível identificar em qual datacenter esses recursos estarão alocados.

![alt_text](./img/multi-tenant-1.png "Multi-tenant")

#### 4. Rapid Elasticity (Elasticidade Rápida)

Os recursos computacionais do provedor de nuvem podem ser rapidamente criados e liberados de maneira elástica, e, em alguns casos, de forma automática, em resposta à demanda de utilização.

Para o consumidor, há a percepção de que os recursos são ilimitados e podem ser ampliados rapidamente; no entanto, é fundamental que essa expansão esteja, evidentemente, associada a custos.

#### 5. Measured Service (Serviço Medido)

Refere-se à capacidade que um provedor de serviços em nuvem possui para monitorar e relatar a utilização dos recursos de TI por seus consumidores de maneira transparente. O provedor realiza a cobrança com base no que é medido ou efetivamente consumido, garantindo que essa informação seja clara e de fácil visualização tanto para o consumidor dos serviços quanto para o próprio provedor de nuvem.

Por exemplo, é responsabilidade do provedor de nuvem esclarecer como é realizada a cobrança de uma máquina virtual. Nesse caso, a cobrança pode ser baseada na quantidade de horas em que a máquina virtual permanece ativa ou na quantidade de dias em que está em uso.

### Modelos de Serviços (Service Models)

Um provedor de nuvem, de acordo com a especificação do NIST, deve ser capaz de oferecer serviços em _três modalidades distintas_. Essa especificação não apenas detalha o que cada modalidade oferece ao consumidor, mas também esclarece as responsabilidades tanto do consumidor (você) quanto do provedor de nuvem (Oracle).

![alt_text](./img/iaas-paas-saas-1.png "IaaS, PaaS e SaaS")

>_**__NOTA:__** Para maiores informações sobre as responsabilidades que envolve o uso da nuvem entre você e a Oracle, consulte [Modelo de Responsabilidade Compartilhada para Resiliência](https://docs.oracle.com/pt-br/iaas/Content/cloud-adoption-framework/oci-shared-responsibility.htm)._

### IaaS - Infrastructure as a Service (Infraestrutura como Serviço)

É a capacidade que um provedor de serviços em nuvem tem de oferecer uma infraestrutura de processamento (compute), armazenamento (storage) e rede (network). Dessa forma, o consumidor não precisa se preocupar em gerenciar a virtualização, a infraestrutura física (como cabeamento, ar condicionado, energia elétrica, entre outros) ou os dispositivos de rede (switches e roteadores).

### PaaS - Platform as a Service (Plataforma como Serviço)

O provedor de nuvem oferece uma plataforma que permite aos usuários executar, desenvolver e gerenciar aplicações. Este modelo abstrai os detalhes relacionados à infraestrutura subjacente, como rede, virtualização e sistema operacional. Como resultado, é um modelo mais fácil de operar e mais econômico em comparação ao modelo IaaS.

Um exemplo de serviço de plataforma é o [OCI Functions](../chapter-5/functions.md), que será abordado posteriormente. Ao utilizar o Functions, você é responsável apenas pelo _código da sua função_, enquanto a criação da infraestrutura computacional necessária para executá-la fica a cargo do OCI. Isso inclui a configuração da rede, a criação das máquinas virtuais para rodar o código, o download do contêiner, entre outros.

### SaaS - Software as a Service (Software como Serviço)

São aplicativos hospedados na nuvem que funcionam sem a necessidade de download ou instalação local. Nesse modelo, o consumidor não gerencia ou controla a infraestrutura subjacente, que inclui redes, servidores e sistemas operacionais.

A Oracle oferece uma ampla gama de soluções empresariais no modelo SaaS, incluindo o [Oracle ERP Cloud](https://www.oracle.com/erp-4/), [Oracle HCM Cloud](https://www.oracle.com/human-capital-management-4/), [Oracle CX Cloud](https://www.oracle.com/cx/platform/) e [Oracle SCM Cloud](https://www.oracle.com/scm-4/), entre outras.

Todas essas soluções são softwares prontos para uso e acessíveis através de um navegador web. Você pode personalizar o software para atender às suas necessidades específicas, sem qualquer interação com a infraestrutura computacional subjacente utilizada pelo software.

## Modelos de Implantação (Deployment Models) 

### Nuvem Pública

A infraestrutura da Computação em Nuvem é disponibilizada e comercializada para o público em geral. Este é o modelo mais amplamente utilizado e oferecido por grandes corporações, como a Oracle.

### Nuvem Privada

A infraestrutura da Computação em Nuvem é destinada ao uso exclusivo de uma única organização. As tecnologias em nuvem são implementadas em ambientes controlados, onde tanto o provedor quanto o consumidor pertencem à mesma entidade.

### Nuvem Híbrida

A infraestrutura da Computação em Nuvem geralmente é composta por duas ou mais nuvens (privada, comunitária ou pública) interconectadas entre si.

Um exemplo é o ["Oracle Cloud at Customer"](https://www.oracle.com/cloud/cloud-at-customer/), que implementa toda a tecnologia de Computação em Nuvem diretamente no datacenter do cliente. Além disso, essa solução se conecta aos serviços de nuvem pública da Oracle.

### Nuvem Comunitária

A infraestrutura da Computação em Nuvem é utilizada por uma comunidade específica de clientes de diferentes organizações que compartilham interesses comuns. A administração da nuvem comunitária é geralmente realizada por administradores da própria comunidade, embora em alguns casos possa ser gerenciada por um terceiro.

## Outras Terminologias

A seguir será apresentado algumas terminologias comuns relacionadas à Computação em Nuvem:

### Alta disponibilidade (High Availability - HA)

Ambientes computacionais configurados para estarem sempre disponíveis (24 horas por dia, 7 dias por semana, 365 dias por ano). Esses ambientes contam com hardware redundante e uma arquitetura de software projetada para alta disponibilidade, eliminando pontos únicos de falha. Em caso de qualquer falha, componentes de backup são acionados de forma transparente, garantindo que não haja impacto para o usuário final.

### Tolerante a falhas (Fault Tolerance)

Descreve como um provedor de Computação em Nuvem assegura um nível mínimo de indisponibilidade para os serviços oferecidos aos seus consumidores.

>_**__NOTA:__** Consulte [Objetivos de Nível de Serviço para Serviços de Nuvem Pública Oracle PaaS e IaaS](https://docs.oracle.com/pt-br/iaas/Content/General/Reference/servicelevelobjectives.htm) para obter mais informações sobre os tempos de SLA dos serviços disponíveis no OCI._

### Escalabilidade (Scalability)

Representa a capacidade de um recurso de TI de se adaptar a variações na demanda de uso, seja ela crescente ou decrescente.

Existem diferentes tipos de escalabilidade dos serviços, que incluem:

#### Scaling Out/In

Conhecida como _escalabilidade horizontal_, essa abordagem envolve a alocação ou liberação de recursos de TI do mesmo tipo.

![alt_text](./img/scale-out-in-1.png "Scaling Out/In")

A escalabilidade horizontal consiste em adicionar mais servidores iguais lateralmente, com o objetivo de aumentar a capacidade geral de processamento ao distribuir a carga de trabalho.

# TODO: descrever cluster de computadores.

#### Scaling Up/Down

Conhecida como _escalabilidade vertical_, essa abordagem é menos comum, pois, além de ser mais cara, frequentemente resulta na indisponibilidade dos recursos envolvidos durante o processo.

![alt_text](./img/scale-up-down-1.png "Scaling Up/Down")

É importante lembrar que o hardware possui limites quanto à quantidade máxima de memória que pode ser disponibilizada e ao aumento da capacidade de processamento, entre outros fatores.

### Elasticidade (Elasticity)

Capacidade de adicionar ou remover recursos com o mínimo de atrito e sem causar indisponibilidade. Por exemplo, adicionar mais espaço em disco a um servidor que está em funcionamento.


## Outras definições de Computação em Nuvem

Algumas definições adicionais que ajudam a esclarecer o conceito de Computação em Nuvem:

- **[2008, Gartner](https://www.gartner.com/en/documents/697413)**

    - _"...um estilo de computação no qual recursos escaláveis e elásticos habilitados para TI, são fornecidos como um serviço a clientes externos que usam tecnologias da Internet."_

- **[Forrester Research](https://www.forrester.com/blogs/09-10-02-assessing_the_maturity_of_cloud_computing_services/)**

    - _"...capacidades de TI padronizadas (serviços, software ou infraestrutura) entregues via tecnologias da Internet em um modelo de self-service no qual se paga somente por aquilo que é usado."_

- **[Cloud Computing: Concepts, Technology & Architecture. Prentice Hall, 2013](https://amzn.to/3POEJZE)**

    - _"A computação em nuvem é uma forma especializada de computação distribuída que introduz modelos de utilização para provisionar remotamente recursos escaláveis e medidos."_

- **[Revistausp, n. 97 (2013): COMPUTAÇÃO EM NUVEM ](https://www.revistas.usp.br/revusp/issue/view/5058)**

    - _"Grosso modo, seria possível definir “nuvem” como a possibilidade de acessarmos qualquer dado – seja arquivo, programa e serviço – de qualquer lugar do planeta, a qualquer hora do dia."_

- **Definição Genérica**

    - _"Computação em Nuvem é um modelo computacional que permite escalar o seu negócio, pagando apenas pelos recursos utilizados."_


