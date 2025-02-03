# 1.1 O que é Computação em Nuvem?

_"A verdadeira disrupção não acontece em seu data center, mas sim na nuvem." - Autor: Anônimo_

## 1.2 Um pouco de História

## 1.3 Definições do NIST

Computação em Nuvem ou Cloud Computing não é um conceito novo e é difícil definir seu significado em poucas palavras. É necessário compreender um conjunto de definições para entender de fato o que é a Computação em Nuvem.

Um documento que detalha os conceitos relacionados à definição de Computação em Nuvem é o ["The NIST Definition of Cloud Computing"](https://csrc.nist.gov/pubs/sp/800/145/final), publicado em setembro de 2011. Esse documento é amplamente reconhecido como uma referência essencial na área de Computação em Nuvem.

De acordo com o NIST, a Computação em Nuvem é um modelo que possibilita o acesso, por meio da Internet, a um conjunto de recursos computacionais (como rede, armazenamento, servidores e serviços) que podem ser rapidamente criados e liberados de maneira simples, sem a necessidade de intervenção humana, como, por exemplo, ligar para um helpdesk para solicitar a criação de um servidor.

O NIST também especifica que um provedor de Computação em Nuvem deve apresentar _cinco características essenciais_. Além disso, o usuário que consome os serviços deve ser capaz de implantar sua aplicação ou provisionar sua infraestrutura, utilizando um dos _três modelos de serviço_ disponíveis (IaaS, PaaS ou SaaS), escolhendo entre um dos _modelos de implementação_ (nuvem pública, privada, híbrida ou comunitária).

Iniciaremos com a descrição das _cinco características essenciais_ que todo provedor de nuvem deve obrigatóriamente ter para ser reconhecido como um verdadeiro provedor de serviços em nuvem. Em seguida, abordaremos os _três tipos de serviços disponíveis_ e, por fim, discutiremos os _quatro modelos de implantação_.

### 1.3.1 Cinco Características Essenciais

Estas são as características essenciais que devem estar presentes quando se trata de Computação em Nuvem. Em essência, um provedor de serviços que oferece Computação em Nuvem deve, no mínimo, possuir as seguintes características essenciais:

#### On-demand self-service (Serviço sob demanda)

Um usuário que consome serviços em nuvem pode criar servidores, redes, bancos de dados e outros recursos conforme a sua necessidade, tudo isso por meio da rede, sem precisar de qualquer intervenção humana por parte do provedor de nuvem.

#### Broad Network Access (Amplo Acesso à Rede)

Os recursos computacionais estão disponíveis por meio da rede e devem ser acessíveis através de mecanismos padronizados, permitindo seu uso em dispositivos como celulares, tablets, laptops e estações de trabalho.

A expressão _"mecanismos padronizados"_ refere-se a métodos, protocolos ou interfaces que são amplamente aceitos e utilizados na indústria, que garantem a comunicação e a operação eficaz entre diferentes sistemas e serviços. Nesse contexto, podemos citar o protocolo TCP/IP, que é universalmente adotado, padronizado por meio de documentos RFC (Request for Comments) e implementado pela maioria dos sistemas operacionais disponíveis. Em outras palavras, o uso do protocolo TCP/IP serve como um meio padronizado para criar ou acessar os recursos oferecidos pelo provedor de nuvem.

#### Resource Pooling (Agrupamento de Recursos)

Os recursos computacionais de um provedor de nuvem são agrupados para atender a múltiplos clientes, que permanecem isolados uns dos outros, por meio de um modelo conhecido como _multi-tenant_ (multilocatário). 

Empresas ou indivíduos pagam para acessar um _pool virtual de recursos compartilhados_, incluindo serviços de computação, armazenamento e rede, que estão localizados em servidores remotos, pertencentes e gerenciados por provedores de serviços. 

Os diferentes recursos, tanto físicos quanto virtuais, são dinamicamente atribuídos e reatribuídos conforme a demanda do cliente. Geralmente, o cliente não tem controle ou conhecimento sobre a localização exata dos recursos fornecidos pelo provedor de nuvem. 

Por exemplo, no OCI ao escolher a região _"Brazil East (São Paulo)"_, o usuário é informado de que seus recursos serão criados no Brasil, especificamente em alguma das cidades da grande _São Paulo_. No entanto, não é possível identificar em qual datacenter esses recursos estarão alocados.

![alt_text](./img/multi-tenant-1.png "Multi-tenant")

#### Rapid Elasticity (Elasticidade Rápida)

Os recursos computacionais do provedor de nuvem podem ser rapidamente criados e liberados de maneira elástica, e, em alguns casos, de forma automática, em resposta à demanda de utilização.

Para o consumidor, há a percepção de que os recursos são ilimitados e podem ser ampliados rapidamente; no entanto, é fundamental que essa expansão esteja, evidentemente, associada a custos.

#### Measured Service (Serviço Medido)

Refere-se à capacidade que um provedor de serviços em nuvem possui para monitorar e relatar a utilização dos recursos de TI por seus consumidores de maneira transparente. O provedor realiza a cobrança com base no que é medido ou efetivamente consumido, garantindo que essa informação seja clara e de fácil visualização tanto para o consumidor dos serviços quanto para o próprio provedor de nuvem.

Por exemplo, é responsabilidade do provedor de nuvem esclarecer como é realizada a cobrança de uma máquina virtual. Nesse caso, a cobrança pode ser baseada na quantidade de horas em que a máquina virtual permanece ativa ou na quantidade de dias em que está em uso.

### 1.3.2 Modelos de Serviços (Service Models)

Um provedor de nuvem, de acordo com a especificação do NIST, deve ser capaz de oferecer serviços em _três modalidades distintas_. Essa especificação não apenas detalha o que cada modalidade oferece ao consumidor, mas também esclarece as responsabilidades tanto do consumidor (você) quanto do provedor de nuvem (Oracle).

![alt_text](./img/iaas-paas-saas-1.png "IaaS, PaaS e SaaS")

>_**__NOTA:__** Para maiores informações sobre as responsabilidades que envolve o uso da nuvem entre você e a Oracle, consulte [Modelo de Responsabilidade Compartilhada para Resiliência](https://docs.oracle.com/pt-br/iaas/Content/cloud-adoption-framework/oci-shared-responsibility.htm)._

#### IaaS - Infrastructure as a Service (Infraestrutura como Serviço)

É a capacidade que um provedor de serviços em nuvem tem de oferecer uma infraestrutura de processamento (compute), armazenamento (storage) e rede (network). Dessa forma, o cliente não precisa se preocupar em gerenciar a virtualização, a infraestrutura física (como cabeamento, ar condicionado, energia elétrica, entre outros) ou os dispositivos de rede (switches e roteadores).

No contexto do serviço de _[Compute](https://docs.oracle.com/en-us/iaas/Content/Compute/Concepts/computeoverview.htm)_ no OCI, classificado como IaaS, ao criar uma instância, o sistema operacional é pré-instalado. A partir daí, o cliente tem a liberdade de instalar o que desejar; no entanto, a administração total do sistema operacional, incluindo atualizações de software, segurança e gerenciamento de usuários, é de responsabilidade do cliente, e não do provedor de nuvem.

#### PaaS - Platform as a Service (Plataforma como Serviço)

O provedor de nuvem oferece uma plataforma que permite aos usuários executar, desenvolver e gerenciar aplicações. Em outras palavras, o modelo PaaS disponibiliza tecnologias para os desenvolvedores desenvolver suas aplicações.

O modelo também abstrai os detalhes da infraestrutura subjacente, como rede, virtualização e sistema operacional. Isso significa que o cliente não tem acesso direto ao sistema operacional ou ao hardware, e não precisa se preocupar com atualizações de software, por exemplo. Como resultado, esse modelo se torna mais fácil de operar e mais econômico em comparação ao IaaS.

Um exemplo de serviço de plataforma é o [OCI Functions](../chapter-5/functions.md), que será abordado posteriormente. Ao utilizar o Functions, você é responsável apenas pelo _código da sua função_, enquanto a criação da infraestrutura computacional necessária para executá-la fica a cargo do OCI. Isso inclui a configuração da rede, a criação das máquinas virtuais para rodar o código, o download do contêiner, entre outros.

#### SaaS - Software as a Service (Software como Serviço)

São aplicativos hospedados na nuvem que funcionam sem a necessidade de download ou instalação local. Toda a infraestrutura necessária para a execução do software — desde o gerenciamento do hardware e do sistema operacional até a própria aplicação — é gerenciada pelo provedor de nuvem. O cliente é responsável apenas pela configuração, personalização para atender às suas necessidades e uso do software.

A Oracle oferece uma ampla gama de soluções empresariais no modelo SaaS, incluindo o [Oracle ERP Cloud](https://www.oracle.com/erp-4/), [Oracle HCM Cloud](https://www.oracle.com/human-capital-management-4/), [Oracle CX Cloud](https://www.oracle.com/cx/platform/) e [Oracle SCM Cloud](https://www.oracle.com/scm-4/), entre outras.

Todas essas soluções são softwares prontos para uso e acessíveis através de um navegador web. Você pode personalizar o software para atender às suas necessidades específicas, sem qualquer interação com a infraestrutura computacional subjacente utilizada pelo software.

### 1.3.3 Modelos de Implantação (Deployment Models) 

Os modelos de implantação definem as diferentes maneiras pelas quais a infraestrutura de nuvem pode ser provisionada.

#### Nuvem Pública

A infraestrutura da Computação em Nuvem é disponibilizada e comercializada para o público em geral. Este é o modelo mais amplamente utilizado e oferecido por grandes corporações, como a Oracle.

#### Nuvem Privada

A infraestrutura da Computação em Nuvem é destinada ao uso exclusivo de uma única organização. As tecnologias em nuvem são implementadas em ambientes controlados, onde tanto o provedor quanto o consumidor pertencem à mesma entidade.

Em outras palavras, a Private Cloud é um modelo em que os serviços de nuvem são fornecidos dentro de uma infraestrutura privada.

Um exemplo é o _[OCI Dedicated Region](https://www.oracle.com/cloud/cloud-at-customer/dedicated-region/)_, também conhecido como _Oracle Dedicated Region Cloud@Customer_. Essa solução da Oracle permite que as organizações implementem uma região completa da Oracle Cloud em suas próprias instalações ou em um data center específico.

>_**__NOTA:__** Para maiores informações consulte ["Dedicated Region"](https://www.oracle.com/cloud/cloud-at-customer/dedicated-region/)._

#### Nuvem Híbrida

A infraestrutura da Computação em Nuvem geralmente é composta por duas ou mais nuvens (privada, comunitária ou pública) interconectadas entre si.

Um exemplo é o ["Oracle Cloud at Customer"](https://www.oracle.com/cloud/cloud-at-customer/), que implementa toda a tecnologia de Computação em Nuvem diretamente no datacenter do cliente. Além disso, essa solução se conecta aos serviços de nuvem pública da Oracle.

#### Nuvem Comunitária

A infraestrutura da Computação em Nuvem é utilizada por uma comunidade específica de clientes de diferentes organizações que compartilham interesses comuns. A administração da nuvem comunitária é geralmente realizada por administradores da própria comunidade, embora em alguns casos possa ser gerenciada por um terceiro.

## 1.4 Outras definições sobre Computação em Nuvem

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


## 1.5 Terminologias da Computação em Nuvem

A seguir, são apresentados alguns termos comuns relacionados aos benefícios e funcionalidades da Computação em Nuvem:

### 1.5.1 Alta disponibilidade (High Availability - HA)

Ambientes computacionais configurados para estarem sempre disponíveis (24 horas por dia, 7 dias por semana, 365 dias por ano). Esses ambientes contam com hardware redundante e uma arquitetura de software projetada para alta disponibilidade, eliminando pontos únicos de falha. Em caso de qualquer falha, componentes de backup são acionados de forma transparente, garantindo que não haja impacto para o usuário final.

### 1.5.2 Tolerante a falhas (Fault Tolerance)

Descreve como um provedor de Computação em Nuvem assegura um nível mínimo de indisponibilidade para os serviços oferecidos aos seus consumidores.

>_**__NOTA:__** Consulte [Objetivos de Nível de Serviço para Serviços de Nuvem Pública Oracle PaaS e IaaS](https://docs.oracle.com/pt-br/iaas/Content/General/Reference/servicelevelobjectives.htm) para obter mais informações sobre os tempos de SLA dos serviços disponíveis no OCI._

### 1.5.3 Escalabilidade (Scalability)

Representa a capacidade de um recurso de TI de se adaptar a variações na demanda de uso, seja ela crescente ou decrescente.

Existem diferentes tipos de escalabilidade dos serviços, que incluem:

#### Scaling Out/In

Conhecida como _escalabilidade horizontal_, essa abordagem envolve a alocação ou liberação de recursos de TI do mesmo tipo.

![alt_text](./img/scale-out-in-1.png "Scaling Out/In")

A escalabilidade horizontal consiste em adicionar mais servidores iguais lateralmente, com o objetivo de aumentar a capacidade geral de processamento ao distribuir a carga de trabalho.

#### Scaling Up/Down

Conhecida como _escalabilidade vertical_, essa abordagem é menos comum, pois, além de ser mais cara, frequentemente resulta na indisponibilidade dos recursos envolvidos durante o processo.

![alt_text](./img/scale-up-down-1.png "Scaling Up/Down")

É importante lembrar que o hardware possui limites quanto à quantidade máxima de memória que pode ser disponibilizada e ao aumento da capacidade de processamento, entre outros fatores.

### 1.5.4 Elasticidade (Elasticity)

Capacidade de adicionar ou remover recursos com o mínimo de atrito e sem causar indisponibilidade. Por exemplo, adicionar mais espaço em disco a um servidor que está em funcionamento.

## 1.6 Vantagens e Desvantagens da Computação em Nuvem

A seguir, apresento algumas vantagens e desvantagens da utilização da Computação em Nuvem.

### 1.6.1 Vantagens

A computação em nuvem oferece uma variedade de benefícios para as organizações. Na verdade, são tantos os benefícios que se torna quase impossível não considerar a mudança das operações comerciais para uma plataforma baseada na nuvem.

#### Acessível de qualquer lugar e dispositivo

Uma das maiores vantagens da Computação em Nuvem é a possibilidade de acessar dados, aplicações e serviços de qualquer lugar e dispositivo, desde que haja uma conexão com a Internet.

Além disso, a Computação em Nuvem é compatível com uma variedade de dispositivos, como laptops, tablets e smartphones. Isso garante que os usuários possam acessar suas informações de maneira conveniente, seja por meio de um computador no escritório ou de um celular durante um deslocamento.

#### Habilitadora de Startups (Agilidade)

Uma _Startup_ é uma empresa em fase inicial, geralmente dedicada ao desenvolvimento de um produto, serviço ou modelo de negócio inovador e escalável. Essas empresas se destacam por sua capacidade de crescer rapidamente, aproveitando tecnologias emergentes e explorando mercados não atendidos ou ambientes de incerteza.

As startups se beneficiam amplamente da Computação em Nuvem, pois geralmente dispõem de recursos financeiros limitados para transformar suas ideias em software. A nuvem oferece suporte a inovações através de solução mais econômica, permitindo que uma startup, sem capital suficiente, evite a necessidade de construir seu próprio data center para desenvolver, testar e lançar seu software ao público.

Além disso, as startups necessitam de agilidade para criar, remover ou expandir recursos computacionais, a fim de atender a novas demandas de negócios ou para modificar completamente sua stack de tecnologia.

É importante destacar que as vantagens mencionadas aqui beneficiam não apenas as startups, mas também empresas maiores e já consolidadas no mercado.

#### Resiliência

É fácil e economicamente viável configurar sua aplicação para utilizar múltiplos data centers geograficamente distribuídos em diversas regiões do mundo, com o objetivo de aumentar a resiliência e a disponibilidade das aplicações.

Utilizar diversos data centers para projetar uma arquitetura distribuída significa que os serviços são executados em máquinas localizadas em diferentes regiões geográficas, o que reduz o risco de falhas em um único ponto.

#### Escalabilidade

Escalabilidade é a capacidade de um sistema, rede ou processo de aumentar sua capacidade e desempenho de maneira eficiente à medida que a demanda cresce. Um sistema escalável pode acomodar um aumento no volume de dados ou no número de usuários sem comprometer o desempenho.

A Computação em Nuvem proporciona uma infraestrutura flexível que pode ser facilmente dimensionada, permitindo que as organizações ajustem rapidamente seus recursos conforme as necessidades do negócio.

#### Custo-benefício

Seja qual for o modelo de serviço de nuvem escolhido _(IaaS, PaaS ou SaaS)_, você paga apenas pelos recursos que realmente usa. Isso ajuda a evitar o disperdício de dinheiro ao superdimensionar recursos computacionais.

A Computação em Nuvem permite que empresas e indivíduos testem, monitorem e ajustem seus recursos computacionais de forma mais precisa antes de realizar investimentos. Com a nuvem, existe o conceito de _"custo variável"_, pois os gastos são baseados no consumo dos recursos utilizados. Além disso, não há custo inicial para a aquisição de hardware.

A economia gerada pelo uso da nuvem tem permitido que as empresas transformem sua tecnologia e abordagem de gerenciamento, tornando-as mais colaborativas, orientadas por resultados e em tempo real.

#### Computação Ecológica

A Computação em Nuvem é uma solução mais sustentável em comparação com as abordagens tradicionais de TI. Ao migrar para a nuvem, as empresas podem reduzir seu consumo de energia e a pegada de carbono em até 90%, um conceito frequentemente referido como _"TI verde"_.

"TI verde" refere-se à forma como a tecnologia evolui, se desenvolve e se expande em ambientes empresariais e industriais, minimizando impactos negativos no meio ambiente.

### 1.6.2 Desvantagens

Como em qualquer tecnologia, a Computação em Nuvem apresenta tanto vantagens quanto desvantagens. No entanto, as vantagens geralmente superam as desvantagens. Vale destacar que algumas desvantagens são apenas _"pontos de atenção"_ e não constituem limitações irreversíveis.

#### Dependência da Internet

Uma das desvantagens mais comuns da Computação em Nuvem é a dependência de uma conexão à Internet. Uma conexão instável pode dificultar o acesso às informações ou aplicativos necessários.

#### Custos Imprevisíveis

É simples criar recursos computacionais ou serviços na nuvem. No entanto, essa facilidade exige atenção para evitar despesas inesperadas que podem comprometer o orçamento. Manter CPUs ligadas e sem uso, por exemplo, pode resultar em custos desnecessários. 

A ideia ao se utiliar a Computação em Nuvem é sempre dimensionar para baixo, criar um recurso com o mínimo aceitável de CPU e memória e, ir expandindo, aumentando, gradativamente. 

>_**__NOTA:__** Utilizo CPU e memória como exemplos para facilitar a compreensão, mas essa lógica se aplica igualmente a todos os outros serviços disponíveis na nuvem._

No OCI, há ferramentas como o _[Cost Analysis](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/costanalysisoverview.htm)_ que tornam a gestão e o monitoramento dos seus custos mais simples e eficazes.

>_**__NOTA:__** Uma excelente ferramenta é [OCI360 - Oracle Cloud Infrastructure 360º View](https://github.com/dbarj/oci360), que permite visualizar os recursos ativos do seu ambiente no OCI de forma abrangente e intuitiva._

#### Complexidade

A Computação em Nuvem não é um conceito novo, mas está em constante evolução, com novos serviços sendo lançados continuamente. Essa complexidade exige atenção, pois os administradores da nuvem precisam se manter atualizados sobre as inovações, a fim de conhecer novos serviços e otimizar os já existentes. Muitos dos problemas que surgem durante a migração para a nuvem são resultado de uma falta de compreensão clara sobre o que os provedores oferecem.

Outra complexidade está relacionada à forma como os recursos são provisionados e modificados. É simples provisionar diferentes tipos de recursos computacionais com apenas alguns _cliques do mouse_. No entanto, à medida que o número de ativos na nuvem aumenta ou que esses ativos são modificados ao longo do tempo, torna-se desafiador manter um controle eficaz sobre eles.

A boa notícia é que a nuvem oferece diversas maneiras de criar e atualizar sua infraestrutura. Uma dessas opções é por meio de ferramentas de _Infraestrutura como Código (IaC - Infrastructure as Code)_. Ao representar sua infraestrutura em código, o gerenciamento se torna mais eficiente e organizado, além de o código servir como uma forma de documentação. No entanto, isso requer que os administradores tenham conhecimentos em programação.

>_**__NOTA:__** Consulte [Why Infrastructure as Code Matters](https://blogs.oracle.com/ateam/post/why-infrastructure-as-code-matters) para uma visão dos benefícios de utilizar ferramentas de IaC._

#### Interação com o Suporte

Um aspecto que considero importante e que merece atenção é a interação com o _[Suporte](https://www.oracle.com/br/support/)_.

Quando há suspeitas de problemas na infraestrutura na nuvem, os administradores geralmente recorrem ao suporte em busca de assistência para resolvê-los. No entanto, é importante destacar que o suporte pode não tem conhecimento sobre o seu ambiente e não sabe sobre problema que você está enfrentando ao utilizar o OCI.

É essencial manter uma comunicação clara e precisa ao explicar em detalhes o problema. Essa comunicação deve ser elaborada de forma detalhada e, se necessário, incluir um diagrama de arquitetura para facilitar a compreensão.

Lembre-se de que um problema relacionado ao design e à criação de uma arquitetura na nuvem, resultante da falta de conhecimento técnico, não deve ser considerado uma questão que exija a intervenção do suporte. Essa abordagem é um problema comum que observo e que frequentemente gera insatisfação entre os usuários da nuvem. A Oracle conta com diversas equipes especializadas que podem ajudar com essas questões arquiteturais, as quais abordaremos mais adiante.

### 1.7 Conclusão

Neste capítulo, exploramos de forma abrangente o conceito de Computação em Nuvem. Discutimos diversas definições formais relacionadas ao tema e concluímos com uma análise das vantagens e desvantagens associadas à sua utilização.