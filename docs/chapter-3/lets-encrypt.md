# Let's Encrypt e o Serviço de Certificados do OCI

## Let's Encrypt

A comunicação segura na web é garantida pelo HTTPS, que exige a utilização de um certificado digital. Esse certificado permite que os navegadores autentiquem a identidade dos servidores web, assegurando a integridade e a confidencialidade das informações trocadas.

Uma [Autoridade Certificadora (CA - Certification Authority)](https://en.wikipedia.org/wiki/Certificate_authority) é uma entidade responsável pela emissão e gerenciamento de certificados digitais

A única maneira de um servidor na web comprovar sua identidade é por meio de um certificado digital emitido por uma autoridade certificadora confiável e reconhecida. Esse mecanismo é fundamental para estabelecer a confiança em um site.

[Let’s Encrypt](https://letsencrypt.org/pt-br/) é uma organização sem fins lucrativos dedicada a promover uma web mais segura e que respeita a privacidade dos usuários, incentivando e promovendo a adoção em larga escala do HTTPS.

Como uma autoridade certificadora global, a Let’s Encrypt possibilita que pessoas e organizações em todo o mundo obtenham, renovem e gerenciem certificados SSL/TLS de forma gratuita. Esses certificados podem ser utilizados por servidores web para habilitar conexões seguras por meio do protocolo HTTPS.

É possível afirmar que qualquer site pode agora adotar o HTTPS por meio do Let’s Encrypt. Além disso, todos os navegadores modernos já confiam nos certificados emitidos por essa autoridade certificadora.

Vale ressaltar que existem outras autoridades certificadoras disponíveis, como a  [VeriSign](https://pt.wikipedia.org/wiki/VeriSign), [Certisign](https://pt.wikipedia.org/wiki/Certisign) e [DigiCert](https://en.wikipedia.org/wiki/DigiCert), entre outras. No entanto, todas elas cobram taxas pela emissão de certificados.

### Certbot

Vamos iniciar com a instalação da ferramenta [Certbot](https://certbot.eff.org/) e prosseguiremos até a emissão de um certificado digital válido, que será utilizado na aplicação OCI Pizza.

O [Certbot](https://certbot.eff.org/) é uma ferramenta que opera em modo cliente e é utilizada para obter certificados digitais emitidos pela Let’s Encrypt.

>_**__NOTA:__** Existem várias maneiras de instalar o Certbot. Recomendo visitar a página oficial para explorar outras opções de instalação, acessando o link [Certbot Instructions](https://certbot.eff.org/instructions)._

Aqui, seguiremos a instalação do Certbot utilizando Python e seu gerenciador de pacotes, o [pip](https://pt.wikipedia.org/wiki/Pip_(gerenciador_de_pacotes)). Todo o processo será realizado dentro de um [ambiente virtual Python (venv)](https://virtualenv.pypa.io/en/latest/).

```
$ python3 -m venv venv
$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install --no-build-isolation certbot
```

>_**__NOTA:__** A instalação do Certbot requer que algumas bibliotecas do sistema operacional estejam instaladas previamente. No meu caso, foi necessário instalar os pacotes libffi-dev, python3-dev e openssl-dev para assegurar uma instalação bem-sucedida do Certbot. Para mais informações, consulte o link [System Requirements](https://eff-certbot.readthedocs.io/en/latest/install.html#system-requirements)._

Após a instalação, você pode verificar a versão do Certbot utilizando o comando abaixo:

```
(venv) $ venv/bin/certbot --version
certbot 3.0.1
```

### Obtendo um certificado por meio do DNS Challenge

Uma das formas de obter um certificado digital emitido pelo Let’s Encrypt é através do DNS Challenge. Esse método é utilizado para comprovar ao Let’s Encrypt que somos os proprietários do domínio "ocipizza.com.br". Assim, será emitido um certificado digital válido para um host (www) associado a esse domínio.

>_**__NOTA:__** O comando abaixo será executado com o usuário root. Se você estiver utilizando outro usuário, será necessário criar alguns diretórios com as permissões adequadas. Para mais detalhes, consulte a documentação oficial no link [Documentation](https://letsencrypt.org/docs/)._

```
(venv) # venv/bin/certbot certonly \
> --manual \
> --preferred-challenges dns -d www.ocipizza.com.br 
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Python 3.8 support will be dropped in the next planned release of Certbot - please upgrade your Python version.
Requesting a certificate for www.ocipizza.com.br

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.www.ocipizza.com.br.

with the following value:

XaAAAAAAAOZ-uUU-BaCOPAPAMdamsDASKDASAI_AAOE

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.www.ocipizza.com.br.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

A saída do comando acima corresponde a um registro DNS do tipo TXT _(\_acme-challenge.www.ocipizza.com.br)_ e seu respectivo valor _(XaAAAAAAAOZ-uUU-BaCOPAPAMdamsDASKDASAI\_AAOE)_. Antes de prosseguir, é necessário adicionar esse registro com o valor correspondente no domíno "ocipizza.com.br" no [Serviço de DNS Público](https://docs.oracle.com/en-us/iaas/Content/DNS/Concepts/gettingstarted.htm) do OCI:

```
$ oci dns record domain patch \
> --zone-name-or-id "ocipizza.com.br" \
> --domain "_acme-challenge.www.ocipizza.com.br" \
> --scope "GLOBAL" \
> --items '[{"domain":"_acme-challenge.www.ocipizza.com.br.", "rdata": "XaAAAAAAAOZ-uUU-BaCOPAPAMdamsDASKDASAI_AAOE", "rtype"
: "TXT", "ttl": 60}]'
```

Tendo os valores inseridos no DNS, é possível seguir novamente com o Certbot que irá então, se tudo estiver correto, emitir o certificado para o host "www" do domínio "ocipizza.com.br":

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/www.ocipizza.com.br/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/www.ocipizza.com.br/privkey.pem
This certificate expires on 2025-03-13.
These files will be updated when the certificate renews.

NEXT STEPS:
- This certificate will not be renewed automatically. Autorenewal of --manual certificates requires the use of an authentication hook script (--manual-auth-hook) but one was not provided. To renew this certificate, repeat this same certbot command before the certificate's expiry date.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Neste caso, o certificado e a chave privada foram salvos nos diretórios correspondentes do sistema operacional:

- **Certificados Intermediários e Certificado do Domínio**:

    - /etc/letsencrypt/live/www.ocipizza.com.br/fullchain.pem

- **Chave Privada**

    - /etc/letsencrypt/live/www.ocipizza.com.br/privkey.pem

## Serviço de Certificados do OCI

O [Serviço de Certificados](https://docs.oracle.com/en-us/iaas/Content/certificates/overview.htm) do OCI é uma solução dedicada ao gerenciamento de certificados digitais. Além de gerenciar todo o ciclo de vida de um certificado, incluindo operações de renovação e revogação, o serviço também emite novos certificados e permite a importação de certificados já emitidos.

>_**__NOTA:__** Todos os comandos utilizados neste capítulo estão disponíveis nos scripts [scripts/chapter-3/cert-saopaulo.sh](../scripts/chapter-3/cert-saopaulo.sh) e [scripts/chapter-3/cert-vinhedo.sh](../scripts/chapter-3/cert-vinhedo.sh)._

Utilizar o Serviço de Certificados do OCI é especialmente vantajoso quando se tem vários Load Balancers que compartilham o mesmo certificado para o HTTPS. Ao chegar o momento de substituir esse certificado, como em casos de expiração, você pode realizar a alteração diretamente no Serviço de Certificados, em vez de precisar atualizar cada Load Balancer individualmente.

Primeiramente, é necessário separar do arquivo _fullchain.pem_ a parte que corresponde ao certificado da aplicação da parte que se refere aos certificados intermediários. Isso pode ser feito utilizando o script abaixo:

```
# awk 'BEGIN {
    c=0;
} 
/-----BEGIN CERTIFICATE-----/ {
    c++; 
    if (c==1) {
        print > "cert.pem";
    } else {
        print > "chain.pem";
    }
} !/-----BEGIN CERTIFICATE-----/ {
    if (c==1) {
        print >> "cert.pem";
    } else if (c>1) {
        print >> "chain.pem";
    }
}' /etc/letsencrypt/live/www.ocipizza.com.br/fullchain.pem
```

Foram criados dois arquivos, além da chave privada, que já existia em outro diretório e foi movida para este local para facilitar o processo de importação.

```
# ls -1 *.pem
cert.pem
chain.pem
privkey.pem
```

- **cert.pem**

    - Arquivo do Certificado Digital da aplicação (www.ocipizza.com.br)

- **privkey.pem**

    - Chave Privada do Certificado Digital da aplicação.

- **chain.pem**

    - Arquivo que contém os Certificados Intermediários utilizados pelo Let's Encrypt. 

Para criar e importar o certificado no Serviço de Certificados, utilize o comando abaixo:

```
$ oci --region "sa-saopaulo-1" certs-mgmt certificate create-by-importing-config \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --cert-chain-pem "$(cat chain.pem)" \
> --certificate-pem "$(cat cert.pem)" \
> --private-key-pem "$(cat privkey.pem)" \
> --name "certificado-ocipizza" \
> --description "Certificado Digital da Aplicação OCI Pizza." \
> --wait-for-state "ACTIVE"
```

O comando abaixo é utilizado para obter o OCID do certificado recém-importado:

```
$ oci --region "sa-saopaulo-1" certs-mgmt certificate list \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc" \
> --all \
> --name "certificado-ocipizza" \
> --lifecycle-state "ACTIVE" \
> --query 'data.items[].id'
[
  "ocid1.certificate.oc1.sa-saopaulo-1.aaaaaaaaaaaaaaaabbbbbbbbccc"
]
```