# 0. Instalação e execução em ambiente de desenvolvimento

## Infraestrutura OCI

```
$ pwd
/home/darmbrust/oci-pizza-proj
```

```
$ cd opentofu/
```

```
$ mv terraform.tfvars-example terraform.tfvars
```

```
$ tofu apply -auto-approve
```

## Instalando as dependências da aplicação Web

```
$ pwd
/home/darmbrust/oci-pizza-proj
```

```
$ cd webapp/
```

```
$ python3 -m venv venv

$ source venv/bin/activate
(venv) $
```

```
(venv) $ pip install -r requirements.txt
```

## Dados iniciais

```
$ pwd
/home/darmbrust/oci-pizza-proj
```

```
$ source webapp/venv/bin/activate
(venv) $
```

```
(venv) $ cd data/
```

```
(venv) $ export NOSQL_COMPARTMENT_OCID='ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc'
```

```
(venv) $ python load.py
[INFO] Upload IMAGE "pizza-moda-da-casa.jpg" ... OK!
[INFO] Upload IMAGE "pizza-milho-mussarela.jpg" ... OK!
[INFO] Upload IMAGE "pizza-hot-dog.jpg" ... OK!
[INFO] Upload IMAGE "pizza-calabresa.jpg" ... OK!
[INFO] Upload IMAGE "pizza-portuguesa.jpg" ... OK!
[INFO] Upload IMAGE "pizza-fran-bacon.jpg" ... OK!
[INFO] Upload IMAGE "pizza-peperone.jpg" ... OK!
[INFO] Upload IMAGE "pizza-bauru.jpg" ... OK!
[INFO] Upload IMAGE "pizza-lombinho.jpg" ... OK!
[INFO] Upload IMAGE "pizza-frango-mussarela.jpg" ... OK!
[INFO] Upload IMAGE "pizza-marguerita.jpg" ... OK!
[INFO] Upload IMAGE "pizza-abobrinha.jpg" ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
[INFO] Insert NoSQL ROW ... OK!
```

## Iniciando e testando a aplicação

```
$ pwd
/home/darmbrust/oci-pizza-proj
```

```
(venv) $ cd webapp/ocipizza/
```

```
(venv) $ export NOSQL_COMPARTMENT_OCID='ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc'
```

```
(venv) $ flask run --host 0.0.0.0
```