# 5.4 - Functions

[Oracle Functions](https://docs.oracle.com/en-us/iaas/Content/Functions/Concepts/functionsoverview.htm), ou simplesmente [Functions](https://docs.oracle.com/en-us/iaas/Content/Functions/Concepts/functionsoverview.htm), é uma plataforma _serverless_ que possibilita a criação e execução de códigos na infraestrutura do OCI, sem a necessidade de provisionar, configurar ou gerenciar servidores.

_Serverless_ é usado para descrever uma plataforma capaz de executar código e que abstrai a gestão de servidores. Embora o nome possa sugerir a ausência de servidores, na verdade, eles estão presentes, mas a sua administração é completamente gerenciada pelo provedor de nuvem. Isso permite que os desenvolvedores se concentrem na lógica de suas aplicações, sem se preocupar com a infraestrutura subjacente.

Em vez de precisar criar e configurar servidores, você simplesmente faz o deployment do seu código e o OCI se encarrega de provisionar a infraestrutura necessária para executar a sua aplicação. Isso inclui também a escalabilidade automática dos recursos utilizados, garantindo que sua aplicação possa se adaptar às variações de demanda sem a necessidade de intervenção manual.

OCI Functions é baseado no projeto de código aberto [Fn Project](https://fnproject.io/), que oferece uma plataforma de _Função como Serviço (FaaS - Function as a Service)_ para o desenvolvimento e execução de aplicações serverless. A escolha em usar um projeto de código aberto é evitar o _vendor lock-in_, comum em outras plataformas serverless. Aplicações desenvolvidas usando o Fn Project não estão sujeitas a esse lock-in, permitindo que sejam executadas localmente ou em qualquer outro provedor de nuvem.

![alt_text](./img/oci-functions-2.png "Fn Project")

>_**__NOTA:__** Os termos BaaS (Backend as a Service) ou FaaS (Function as a Service), também são usados para descrever este modelo computacional._

Embora o conceito de serverless possa parecer a solução mágica e definitiva para a construção de aplicações, ele não é uma _"bala de prata"_ que se aplica a todos os casos. Veremos que existem algumas limitações e seu uso exige uma nova abordagem na forma como as aplicações são desenvolvidas.

## Funções em Contêineres

Functions é, essencialmente, um contêiner que é executado na infraestrutura do OCI, seja por meio de uma chamada direta ou em resposta a um evento específico. O conceito de criação e envio do contêiner ao _[OCIR](https://docs.oracle.com/en-us/iaas/Content/Registry/home.htm)_ se aplica da mesma forma, mas de maneira diferente, utilizando o utilitário de linha de comando fornecido pela instalação do Fn Project.

As funções que você cria devem ser projetadas para executar uma única tarefa de forma simples e eficiente. O serviço não é destinado à execução de grandes aplicações e sim, pequenas tarefas, como, por exemplo, realizar um processamento de dados simples e, ao final, enviar um e-mail.

Aqui, já encontramos uma limitação em relação ao código que será executado como uma função: o tempo total de execução e a quantidade de memória disponível para que a função realize a sua tarefa.

Ao criar uma função, é obrigatório informar o _"tempo máximo de vida do contêiner"_ como também, a quantidade máxima de memória que ele pode utilizar. O tempo máximo de execução pode ser configurado entre 30 segundos e 300 segundos (5 minutos). Em relação à memória, é possível configurar entre 128 MB e 3072 MB (3 GB).

Isso significa que, se a execução da função ultrapassar o tempo máximo especificado, o OCI encerrará a função. Da mesma forma, se a função exigir mais memória do que a alocada, o OCI também encerrará a função. 

Outra limitação importante é a quantidade máxima de dados que podem ser enviados para a função, bem como a quantidade máxima de dados que ela pode retornar. Esses limites são fixos em 6 MB e não podem ser alterados.

Essas limitações também se refletem em como o serviço é cobrado. A cobrança é baseada no tempo em que o contêiner permaneceu ativo e na quantidade de memória alocada.

Por exemplo, ao calcular rapidamente o custo do serviço para 200 chamadas por dia, o que totaliza 6.200 chamadas por mês, considerando que cada função é executada por 300 segundos e utiliza 256 MB de memória, o custo mensal seria de R$ 5,08.

![alt_text](./img/oci-functions-1.png "OCI Functions - Estimated Monthly Cost")

>_**__NOTA:__** Sempre verifique o custo do serviço atráves do link [OCI Cost Estimator](https://www.oracle.com/cloud/costestimator.html) para obter valores atualizados._

É essencial compreender a tecnologia para projetar de maneira eficaz quais tipos de aplicações ou funcionalidades podem se beneficiar do OCI Functions. Neste capítulo, utilizaremos como exemplo duas funcionalidades da aplicação OCI Pizza que fazem uso do OCI Functions para enviar e-mails ao usuário final.

## Cold Start e Hot Start

Como já mencionado, uma função é essencialmente um contêiner que é executado pelo OCI. Essa execução pode ser realizada por meio do utilitário de linha de comando fornecido pelo Fn Project, OCI CLI, SDKs, chamadas HTTP diretas ou em resposta a eventos configuráveis.

Toda execução de aplicações conteinerizadas segue o mesmo processo de deployment. Primeiramente, a imagem do contêiner é baixada do registro (pull) e, em seguida, é executada por uma infraestrutura que suporte a execução de contêineres por exemplo, [Container Instances](./docs/chapter-5/container-instances.md) ou [OKE](./docs/chapter-6/intro.md). 

O tempo total do processo de deployment, desde a inicialização até a disponibilização da função para processar a requisição é denominado **Cold Start**.

**Cold Start** é o termo utilizado em ambientes de computação serverless que se refere ao atraso inicial que ocorre quando uma função é invocado pela primeira vez ou após um período de inatividade _(idle time)_. Em outras palavras, é o tempo total que o provedor de nuvem leva para preparar e disponibilizar a função, permitindo que ela processe a solicitação recebida.

Uma função que foi criada e permanece inativa por um certo período, é encerrada pelo OCI. Se ela for invocada novamente, o período de _cold start_ se reinicia para essa função. 

O período de _cold start_ não pode ser ajustado e é imprevisível, o que significa que não é possível determinar com precisão quanto tempo uma função levará para se tornar ativa e processar uma solicitação. Essa é uma limitação adicional que deve ser levada em conta ao se projetar funções.

Já o termo **Hot Start** tem um significado oposto. Quando uma função ainda está ativa ou, se a infraestrutura de execução estiver _"de pé"_, as requisições para essa função geralmente apresentam um tempo de resposta inferior a um segundo, pois não há necessidade de realizar todo o provisionamento nesse caso. 

É importante dizer que requisições subsequentes são direcionadas ao mesmo contêiner. Se necessário, o OCI escala automaticamente a infraestrutura de forma horizontal para atender a um maior volume de requisições, até um limite máximo de 60 GB de memória alocado para execução de todas as funções. Esse é o limite do tenancy, e, se necessário, é possível solicitar uma alteração para aumentar a capacidade de memória.

Uma forma de garantir que as funções estejam prontas para uso e evitar o cold start é habilitar o Provisioned Concurrency. Essa funcionalidade assegura que a infraestrutura de execução permaneça disponível para um número mínimo de invocações simultâneas, permitindo que as funções sejam acionadas rapidamente.

## Criando Funções

Agora que a teoria e as limitações do uso de funções foram abordadas, é hora de aplicar esse conhecimento na prática e preparar o ambiente para o desenvolvimento de funções.

>_**__NOTA:__** O passo a passo para a instalação do Fn Project e a preparação do ambiente é baseado no documento ["Functions QuickStart on Local Host"](https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsquickstartlocalhost.htm#functionsquickstartlocalhost)._

### Instalação do Fn Project

Primeiramente, na sua máquina local, deve-se instalar o Fn Project através do comando abaixo:

```bash
$ curl -LSs https://raw.githubusercontent.com/fnproject/cli/master/install | sh
[sudo] password for darmbrust:
fn version 0.6.36

        ______
       / ____/___
      / /_  / __ \
     / __/ / / / /
    /_/   /_/ /_/`
```

Uma forma de verificar se a instalação foi concluída com sucesso é utilizando o comando _[fn](https://github.com/fnproject/docs/tree/master/cli)_ que acaba de ser instalado:

```bash
$ fn version
Client version is latest version: 0.6.36
Server version:  ?
```

>_**__NOTA:__** Para mais informações sobre a instalação do Fn Project, consulte [Fn Installation](https://fnproject.io/tutorials/install/)._

### Function Application

Toda função antes de ser criada, deve fazer parte de um [Application](https://docs.oracle.com/en-us/iaas/Content/Functions/Concepts/functionsconcepts.htm#applications) que é um meio usado pelo OCI para agrupar funções que serão executadas tendo configurações em comum. 

As funções dentro de um mesmo Application compartilham a mesma sub-rede, utilizam as mesmas variáveis de ambiente e a mesma arquitetura de processador, possuem configurações de log em comum e são executadas de forma isolada em relação a outras Applications.

A aplicação OCI Pizza utiliza um Application por região para agrupar suas funções, que será criada especificando a sub-rede privada (subnprv) e algumas variáveis de ambiente necessárias.

O comando abaixo cria a Application na região _Brazil East (São Paulo)_:

```bash
$ oci --region "sa-saopaulo-1" fn application create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "fn-appl-ocipizza" \
> --subnet-ids "[\"ocid1.subnet.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\"]" \
> --config "{ 
>     \"OCI_REGION\": \"sa-saopaulo-1\",
>     \"ENV\": \"prd\",    
>     \"NOSQL_COMPARTMENT_OCID\": \"ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc\",
>     \"EMAIL_COMPARTMENT_OCID\": \"ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc\"}" \
> --shape "GENERIC_X86" \
> --wait-for-state "ACTIVE"
```

>_**__NOTA:__** A sub-rede utilizada deve ter pelo menos um determinado número mínimo de endereços IP livres para uso do OCI Functions. Consulte [CIDR Blocks and OCI Functions](https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionscidrblocks.htm) para maiores detalhes._

### Habilitando a captura dos Logs

Toda função, ao ser executada, gera logs. Para facilitar a análise de possíveis problemas que possam impedir a execução correta da função, é uma boa prática habilitar o registro desses logs.

Para habilitar os logs de execução das funções, primeiro é necessário obter o OCID do [Log Group](https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm) que foi criado na seção do Capítulo 1

```bash
$ oci --region "sa-saopaulo-1" logging log-group list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --display-name "ocipizza-loggroup" \
> --query 'data[].id'
[
  "ocid1.loggroup.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

Em seguida, obtenha o OCID do Application:

```bash
$ oci --region "sa-saopaulo-1" fn application list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "fn-appl-ocipizza" \
> --lifecycle-state "ACTIVE" \
> --query 'data[].id'
[
  "ocid1.fnapp.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```

Com essas informações, já é possível habilitar os logs para a execução das funções:

```bash
$ oci --region "sa-saopaulo-1" logging log create \
> --log-group-id "ocid1.loggroup.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --display-name "log-service-fn" \
> --log-type "SERVICE" \
> --retention-duration 30 \
> --is-enabled "true" \
> --configuration "{
>     \"archiving\": {
>         \"isEnabled\": false
>     },
>     \"compartmentId\": \"ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc\",
>     \"source\": {
>         \"category\": \"invoke\",
>         \"resource\": \"ocid1.fnapp.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc\",
>         \"service\": \"functions\",
>         \"sourceType\": \"OCISERVICE\"}}" \
> --wait-for-state "SUCCEEDED"
```

### Configurações iniciais do Fn Project

Antes de construir funções é necessário configurar o Fn Project de acordo com alguns parametrôs do OCI.

1. Criar um contexto de utilização especificando o parâmetro _--provider oracle_:

```bash
$ fn create context ocipizza-ctx --provider oracle
Successfully created context: ocipizza-ctx
```

2. Após, utilize o contexto que foi recentemente criado:

```bash
$ fn use context ocipizza-ctx
Now using context: ocipizza-ctx
```

```bash
$ fn update context ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc
```

```bash
$ fn update context oracle.image-compartment-id ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc
```

```bash
$ fn update context api-url https://functions.sa-saopaulo-1.oci.oraclecloud.com
```

```bash
$ fn update context registry sa-saopaulo-1.ocir.io/grxmw2a9myyj/fn-repo
```

```bash
$ docker login -u 'grxmw2a9myyj/darmbrust@gmail.com' sa-saopaulo-1.ocir.io
```

>_**__NOTA:__** Consulte o [Fn CLI Guide](https://github.com/fnproject/docs/tree/master/cli) para obter mais detalhes sobre os comandos e suas opções disponíveis._

## Funções da aplicação OCI Pizza

Existem duas funções que estão no diretório _"services/"_ e que são utilizadas pela aplicação OCI Pizza:

- **fn-user-registry-email**

    - Função destinada a registrar um novo usuário. 
    - Após o usuário submeter seus dados de cadastro por meio da aplicação, a função insere essas informações no banco de dados e, em seguida, envia um e-mail ao usuário para confirmar seu cadastro. 

- **fn-password-recovery-email**

    - Função destinada para recuperação de senha do usuário.
    - Após o usuário submeter seu endereço de e-mail, essa função será executada para gerar um link de recuperação de senha, que será enviado ao usuário por e-mail.

Todas elas, após o seu devido processamento, utilizam o serviço [Email Delivery](../chapter-3/email-delivery.md) para enviar um e-mail ao usuário.

Aqui apresentarei os detalhes sobre como criar uma função, utilizando como exemplo a função _fn-password-recovery-email_.

Primeiramente, é necessário criar a função utilizando alguns parâmetros por meio do comando _[fn init](https://github.com/fnproject/docs/blob/master/cli/ref/fn-init.md)_:

```bash
$ fn init --runtime python3.8 --memory 256 --timeout 120 fn-password-recovery-email
Creating function at: ./fn-password-recovery-email
Function boilerplate generated.
func.yaml created.
```

>_**__NOTA:__** A criação ou inicialização (init) de uma função no contexto do Fn Project podem ser interpretadas de maneira equivalente e possuem um significado similar.._

Note que, no comando acima, além de definir a _memória alocada (--memory)_ e o _tempo máximo de execução (--timeout)_, é obrigatório especificar o _ambiente de execução_ responsável por executar o código da função _(--runtime)_. Para a aplicação OCI Pizza, todo o código foi desenvolvido na linguagem de programação Python, versão 3.8.

>_**__NOTA:__** É importante destacar que é possível criar funções usando outras linguagens de programação. Para mais informações, consulte a seção de [Tutorials](https://fnproject.io/tutorials/) na documentação oficial do Fn Project._

O comando após ser executado cria o diretório _"fn-password-recovery-email/"_ com três arquivos:

```bash
$ ls -1 fn-password-recovery-email/
func.py
func.yaml
requirements.txt
```

- **func.py**

    - Arquivo principal e o primeiro a ser chamado quando a função é invocada.

- **func.yaml**

    - Arquivo de configuração da função que contém informações essenciais para sua execução. 

- **requirements.txt**

    - Arquito que contém a lista de depêndencias Python necessárias para executar a função.

Como mencionado anteriormente, uma função é essencialmente um contêiner. Isso significa que podemos criar diretórios, adicionar pacotes extras para expandir suas funcionalidades, desenvolver bibliotecas específicas, entre outras possibilidades, sempre considerando suas limitações, especialmente em relação ao tempo máximo de execução e à memória disponível.

A função _fn-password-recovery-email_ apresenta a seguinte estrutura de arquivos e diretórios:

```bash
$ tree .
.
├── func.py
├── func.yaml
├── modules
│   ├── __init__.py
│   ├── email.py
│   ├── nosql.py
│   ├── user.py
│   └── utils.py
└── requirements.txt

1 directory, 8 files
```

### Build e Push