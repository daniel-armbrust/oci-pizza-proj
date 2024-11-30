# 2. Entendendo os Contêineres

## Contêineres

Definir contêineres de forma concisa pode ser desafiador, pois envolve diversos conceitos interligados. Para facilitar a compreensão, apresentarei alguns princípios fundamentais que ajudarão a esclarecer o que são contêineres e como eles funcionam.

### Processos

Programa é uma entidade passiva onde as suas instruções são armazenadas em disco. Pode-se dizer também que, um programa é um _arquivo executável_. 

Assim que o programa é executado pelo usuário, ele se transforma em uma entidade ativa, com suas instruções sendo processadas pela CPU do computador. Em outras palavras, o programa passa a ser considerado um processo.

Em resumo, um processo é uma instância de um programa que está sendo executado.

Todo processo possui um número único, denominado PID (Process Identifier ou Identificador de Processo), que é utilizado para sua identificação no sistema operacional. Além disso, os processos têm a capacidade de se comunicar entre si, acessar arquivos e até mesmo enviar dados pela rede.

![alt_text](/imgs/processos-1.png "Processos #1")

Os contêineres, ou Software Containers, foram desenvolvidos como uma solução eficaz para isolar a execução de processos dentro de um sistema operacional. Além dessa capacidade de isolamento, todo o conteúdo de um contêiner pode ser compactado em um único arquivo tarball, resultando no que chamamos de imagem de contêiner. Essa imagem contém tudo o que é necessário para executar o aplicativo, incluindo bibliotecas, dependências e configurações, garantindo um ambiente consistente e portátil.

>_**__NOTA:__** Isolar a execução de processos dentro de um mesmo sistema operacional não é uma ideia nova. Antes do surgimento dos contêineres, tecnologias como Solaris Zones e chroot já desempenhavam essa função, possibilitando a criação de ambientes isolados para a execução de aplicações._

Uma vez gerada, uma imagem de contêiner pode ser transportada e executada em qualquer ambiente que suporte a execução de contêineres. Em outras palavras, os contêineres permitem empacotar uma aplicação juntamente com todas as suas dependências (como frameworks, bibliotecas e arquivos de configuração) em um único _"pacote"_. Isso possibilita que esse pacote seja facilmente transferido e executado em plataformas como a _Oracle Cloud Infrastructure (OCI)_.

Os contêineres revolucionaram o desenvolvimento de software ao oferecer agilidade e simplificar o empacotamento e a distribuição de aplicações. Todas as dependências necessárias para uma aplicação estão incluídas dentro do contêiner, resultando em um pacote autocontido. Isso permite que o mesmo software seja executado em diferentes ambientes (desenvolvimento, teste e produção) sem a necessidade de realizar qualquer modificação.

### Docker

Docker é um conjunto de ferramentas desenvolvido para simplificar a criação, transporte e execução de contêineres. Ele utiliza funcionalidades do kernel do Linux, como namespaces e cgroups, para criar um _"espaço de trabalho isolado"_ conhecido como contêiner. Essa abordagem permite que os desenvolvedores empacotem aplicações e suas dependências de maneira consistente, assegurando que funcionem de forma idêntica em diferentes ambientes.

>_**__NOTA:__** Existem outras ferramentas disponíveis para criar e gerenciar contêineres, como o Podman, por exemplo. No entanto, o Docker continua sendo a ferramenta mais popular e amplamente utilizada no mercado.._

Contêineres não são máquinas virtuais. Enquanto uma máquina virtual inclui um sistema operacional completo e inicializável, um contêiner opera dentro de um sistema operacional existente. Isso significa que um único sistema operacional pode executar múltiplos contêineres, que são significativamente mais leves do que máquinas virtuais completas. Essa leveza permite um uso mais eficiente dos recursos, resultando em tempos de inicialização mais rápidos e uma maior densidade de aplicações em um mesmo ambiente.

### Container Registry

O _Container Registry_ é um serviço fundamental presenten no ecossistema de contêineres pois é ele quem permite armazenar, gerenciar e distribuir imagens de contêiner.

O Container Registry atua como um repositório centralizado onde os desenvolvedores podem armazenar suas imagens de contêiner. Essa funcionalidade permite que as equipes compartilhem e reutilizem imagens de forma eficiente em diversos ambientes, como desenvolvimento, teste e produção.

Além do _Docker Hub_, que é o maior registry público de imagens de contêiner, a Oracle também oferece o seu próprio registry público, acessível através do seguinte link:: [https://container-registry.oracle.com](https://container-registry.oracle.com/)

![alt_text](/imgs/oracle-container-registry-1.png "Oracle Container Registry")

Uma das vantagens do [Oracle Container Registry](https://container-registry.oracle.com/) em comparação com o _Docker Hub_, é que o _Docker Hub_ impõe limites para o download das imagens que ele armazena (rate limits).  Em contrapartida, o Oracle Container Registry não aplica essas restrições, permitindo que os desenvolvedores baixem imagens da Oracle à vontade, sem se preocupar com limitações de uso.

Na aplicação _OCI Pizza_, foi utilizada como _imagem base_ o [Oracle Linux 8](https://container-registry.oracle.com/ords/ocr/ba/os/oraclelinux) na versão _slim_, que é uma imagem mais leve e compacta. Essa versão otimizada permite downloads e implantações mais ágeis, pois contém apenas os componentes essenciais do sistema operacional.

![alt_text](/imgs/oracle-container-registry-2.png "Oracle Linux 8 Slim")

>_**__NOTA:__** Uma Docker Base Image (imagem base do Docker) é uma imagem de contêiner que serve como ponto de partida para a criação de outras imagens. Ela contém o sistema operacional e a sua aplicação._

Para baixar a imagem [Oracle Linux 8 Slim](https://container-registry.oracle.com/ords/ocr/ba/os/oraclelinux) localmente em sua máquina, basta executar o comando abaixo:

```
$ docker pull container-registry.oracle.com/os/oraclelinux:8-slim
```

Com a _imagem baixada_ localmente, é possível criar um contêiner e iniciar um shell a partir do ID dessa _imagem base_:

```
$ docker images
REPOSITORY                                     TAG       IMAGE ID       CREATED       SIZE
container-registry.oracle.com/os/oraclelinux   8-slim    95e2d27d5c61   2 weeks ago   115MB
```

```
$ docker run -it 95e2d27d5c61 bash
bash-4.4# whoami
root
```

### Dockerfile

Um Dockerfile é um arquivo de texto que contém todas as instruções necessárias para criar uma imagem de contêiner. O Dockerfile da aplicação __OCI Pizza__ apresenta o seguinte conteúdo:

```
$ cat webapp/Dockerfile

#
# Dockerfile
#
FROM container-registry.oracle.com/os/oraclelinux:8-slim

LABEL maintainer="Daniel Armbrust <darmbrust@gmail.com>"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=wsgi.py
ENV FLASK_DEBUG=0
ENV FLASK_ENV=production
ENV STATIC_URL=/static
ENV STATIC_PATH=/var/www/ocipizza/app/static

WORKDIR /var/www/ocipizza

COPY requirements.txt ./
COPY docker-entrypoint.sh ./

RUN microdnf update -y && \
    microdnf install -y gcc python38-devel python3.8 && \
    python -m ensurepip && \
    python -m pip install --no-cache-dir --upgrade pip setuptools && \
    python -m pip install --no-cache-dir -r requirements.txt && \
    microdnf clean all && rm -rf /var/cache/yum

RUN adduser -l -d /var/www/ocipizza webapp

COPY --chown=webapp:webapp ./ocipizza /var/www/ocipizza/

USER webapp
EXPOSE 5000

ENTRYPOINT ["./docker-entrypoint.sh"]
```

Para criar a imagem da aplicação, navegue até diretório que contém o arquivo Dockerfile:

```
$ cd webapp/
```

Em seguida, execute o comando abaixo e aguarde sua conclusão:

```
$ docker build -t ocipizza:1.0 .
```

Agora você pode confirmar que a imagem da aplicação foi criada com sucesso utilizando o comando abaixo:

```
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
ocipizza     1.0       532272158f55   13 minutes ago   665MB
```