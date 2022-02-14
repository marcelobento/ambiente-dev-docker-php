Ambiente de desenvolvimento com Docker [PHP 7.4 + Nginx + NODE + Mysql + Postgresql + Oracle]

# Instalação

# Fazer o pull do composer:2
A imagem do php usa o composer
```cmd
docker pull composer:2
```

# Fazer build da imagem do PHP
Navegue até:
```
cd ./docker/php
```
Para evitar problemas com download, tenha disponivel os arquivos 
* oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
* oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
```
Execute o comando:
```cmd
docker build --file php.dockerfile -t php:7.4-fpm .
```

# Fazer build da imagem do NGINX 
Navegue até:
```
cd ./docker/nginx
```
Execute o comando:
```cmd
docker build -f .\nginx.dockerfile -t nginx:1.19 .
```

# Fazer build da imagem do NODE
Navegue até:
```
cd ./docker/node
```
Execute o comando:
```cmd
docker build --file node.dockerfile -t node:14 .
```

# Estrutura de pastas do projeto
A imagem do PHP + NGINX estão com o WORKDIR mapeados da seguinte forma:
```
PHP - /var/www/html
```
```
NGINX - /app
```

O arquivo nginx.default.conf está com o diretório root apontando para /app/public. Caso queira mudar, só alterar a linha 4:
```
root /app/public;
```

A imagem do NODE aponta está com o WORKDIR mapeado para:
```
/app
```

# Banco de Dados
Navegue até:
```
cd ./docker/database
```
Digite o comando
```cmd
docker-compose up -d
```
Vai subir os container do mysql e postgresql


# Finalizando
Depois de tudo buildado e configurado, agora rode o comando:
```cmd
docker-compose up -d
```

Acesse a url http://localhost

Por padrão coloquei um arquivo index.php para mostrar a configuração do servidor php.
