#  api Caixa Virtual

Projeto backend delphi, um aplicativo para caixa de loja virtual.

## Getting Started

Essas instruções fornecerão uma cópia do projeto em execução na sua máquina local para fins de desenvolvimento e teste.

### Pre-requisitos

Você primeiro precisa instalar os binários do boss, gerenciador de dependências para delphi. 

```
[boss](https://github.com/HashLoad/boss)

```

### Intalação

Depois, na pasta no projeto, instale as dependências

```
boss install 

```

## Iniciando o servidor
abrir o projeto no delphi e rodar a aplicação

abra o browser http://localhost:9000

# Uso da API & Endpoints

## Registrar uma loja [POST /api/lojas]

- Request: Adiciona uma nova loja

  - Headers
        Content-type: application/json

  - Body

            {
              "nome": "",
              "email": "",
              "senha": ""
            }

- Response: 200 (application/json)

  - Body

          {
            "_id": "",
            "nome": "",
            "email": ""
          }

## Login com uma Loja [POST /api/authorization]

- Request: Login com as credenciais para receber JSON web token

  - Headers
        Content-type: application/json

  - Body

            {
              "email": "",
              "senha": ""
            }

- Response: 200 (application/json)

  - Body

          {
            "JSON web token"
          }

## Criar uma Categoria [POST /api/categorias]

- Request: Adiciona uma nova categoria

  - Headers
        x-auth-token: JWT
        Content-type: application/json

  - Body

            {
              "nome": ""
            }

- Response: 200 (application/json)

  - Body

          {
              "_id": "",
              "loja": "",
              "nome": ""
          }

## Criar um Caixa [POST /api/caixas]

- Request: Adiciona uma caixa para a loja

  - Headers
        x-auth-token: JWT
        Content-type: application/json

  - Body

            {
              "saldoTotal": ""
            }

- Response: 200 (application/json)

  - Body

          {
              "_id": "",
              "loja": "",
              "saldoTotal": ""
          }

## Criar um Caixa [POST /api/caixa/movimentos]

- Request: Adiciona uma movimentação para o caixa

  - Headers
        x-auth-token: JWT
        Content-type: application/json

  - Body

            {
              "categoriaId": "",
              "tipo":"Saida|Entrada",
              "valor": ,
              "descricao": ""
}

- Response: 200 (application/json)

  - Body

          {
            "_id": "",
            "caixa": "",
            "categoria": {
                "_id": "",
                "nome": ""
              },
            "tipo": "",
            "valor":,
            "descricao": "",
            "data": ""
          }

## Resumo de Caixa [GET /api/caixas]

- Request: Resumo com a movimentação do caixa

  - Headers
        x-auth-token: JWT

- Response: 200 (application/json)

  - Body

          {
            "saldoTotal": "",
            "movimentacoes": [
            {
              "_id": "",
              "categoria": {
                  "_id": "",
                  "nome": ""
                },
              "tipo": "",
              "valor": ,
              "descricao": "",
              "data": ""
            }
          ]
        }


## Construido com

* [Delphi Community](https://www.embarcadero.com/br/products/delphi/starter) - Delphi versão community.
* [boss](https://github.com/HashLoad/boss) - É um gerenciador de dependência para delphi.
* [Horse](https://github.com/HashLoad/horse) - É um Framework web para delphi.

## Autor

* **Rafael Yamauchi** - *Initial work* - [Linkedin](https://www.linkedin.com/in/rafaelyamauchi/)

## Licença

Este projeto é licenciado sobre MIT Licença - veja em [LICENSE.md](LICENSE.md) para mais detalhes.
