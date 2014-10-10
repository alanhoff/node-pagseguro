# node-pagseguro

Integração ao Pagseguro para sistemas usando o Node.js

## Instalação

`npm install pagseguro`

## Como usar

### Para pagamentos únicos

```javascript
    //Inicializar a função com o e-mail e token
    var pag, pagseguro;
    pagseguro = require('pagseguro');
    pag = new pagseguro({
        email : 'suporte@lojamodelo.com.br',
        token: '95112EE828D94278BD394E91C4388F20'
    });

    //Configurando a moeda e a referência do pedido
    pag.currency('BRL');
    pag.reference('12345');

    //Adicionando itens
    pag.addItem({
        id: 1,
        description: 'Descrição do primeiro produto',
        amount: "4230.00",
        quantity: 3,
        weight: 2342
    });

    pag.addItem({
        id: 2,
        description: 'Esta é uma descrição',
        amount: "5230.00",
        quantity: 3,
        weight: 2342
    });

    pag.addItem({
        id: 3,
        description: 'Descrição do último produto',
        amount: "8230.00",
        quantity: 3,
        weight: 2342
    });

    //Configurando as informações do comprador
    pag.buyer({
        name: 'José Comprador',
        email: 'comprador@uol.com.br',
        phoneAreaCode: '51',
        phoneNumber: '12345678'
    });

    //Configurando a entrega do pedido

    pag.shipping({
        type: 1,
        street: 'Rua Alameda dos Anjos',
        number: '367',
        complement: 'Apto 307',
        district: 'Parque da Lagoa',
        postalCode: '01452002',
        city: 'São Paulo',
        state: 'RS',
        country: 'BRA'
    });

    //Configuranto URLs de retorno e de notificação (Opcional)
    //ver https://pagseguro.uol.com.br/v2/guia-de-integracao/finalizacao-do-pagamento.html#v2-item-redirecionando-o-comprador-para-uma-url-dinamica
    pag.setRedirectURL("http://www.lojamodelo.com.br/retorno");
    pag.setNotificationURL("http://www.lojamodelo.com.br/notificacao");

    //Enviando o xml ao pagseguro
    pag.send(function(err, res) {
        if (err) {
            console.log(err);
        }
        console.log(res);
    });
```

### Assinaturas (Pagamentos Recorrentes)

```javascript
    // Inicializa o objeto PagSeguro em modo assinatura
    var pagseguro = require('pagseguro'),
        pag = new pagseguro({
            email : 'suporte@lojamodelo.com.br',
            token: '95112EE828D94278BD394E91C4388F20',
            mode : 'subscription'
        });

    //Configurando a moeda e a referência do pedido
    pag
        .currency('BRL')
        .reference('12345');

    /***********************************
    *     Configura a assinatura       *
    ************************************/

    //Configurando as informações do comprador
    pag.buyer({
        name: 'José Comprador',
        email: 'comprador@uol.com.br',
        phoneAreaCode: '51',
        phoneNumber: '12345678',
        street: 'Rua Alameda dos Anjos',
        number: '367',
        complement: 'Apto 307',
        district: 'Parque da Lagoa',
        postalCode: '01452002',
        city: 'São Paulo',
        state: 'RS',
        country: 'BRA'
    });

    // Configurando os detalhes da assinatura (ver documentação do PagSeguro para mais parâmetros)
    pag.preApproval({
        // charge: 'auto' para cobranças automáticas ou 'manual' para cobranças
        // disparadas pelo seu back-end
        // Ver documentação do PagSeguro sobre os tipos de cobrança
        charge: 'auto',
        // Título da assinatura (até 100 caracteres)
        name: 'Assinatura de serviços',
        // Descrição da assinatura (até 255 caracteres)
        details: 'Assinatura mensal para prestação de serviço da loja modelo',
        // Valor de cada pagamento
        amountPerPayment: '50.00',
        // Peridiocidade dos pagamentos: Valores: 'weekly','monthly','bimonthly',
        // 'trimonthly','semiannually','yearly'
        period: 'monthly',
        // Data de expiração da assinatura (máximo 2 anos após a data inicial)
        finalDate: '2016-10-09T00:00:00.000-03:00'
    });



    //Configurando URLs de retorno e de notificação (Opcional)
    //ver https://pagseguro.uol.com.br/v2/guia-de-integracao/finalizacao-do-pagamento.html#v2-item-redirecionando-o-comprador-para-uma-url-dinamica
    pag
        .setRedirectURL("http://www.lojamodelo.com.br/retorno")
        .setNotificationURL("http://www.lojamodelo.com.br/notificacao");

    // Configurando URL de revisão dos termos de assinatura (Opcional)
    pag.setReviewURL("http://www.lojamodelo.com.br/revisao");

    //Enviando o xml ao pagseguro
    pag.send(function(err, res) {
        if (err) {
            console.log(err);
        }
        console.log(res);
    });
```

### Modo Sandbox

O modo Sandbox do PagSeguro (hoje, 09/10/2014, em beta) permite o desenvolvedor a testar seu código usando o serviço do PagSeguro sem disparar transações reais mas ainda recebendo notificações. Por enquanto ele só dá suporte a pagamentos padrão, logo para testar assinaturas ainda é necessário realizar uma transação real.

Para utilizar o modo Sandbox, basta inicializar a biblioteca com a opção `mode : 'sandbox'` como no exemplo abaixo e utilizá-la para gerar pagamentos avulsos.

```javascript
    // Inicializa o objeto PagSeguro em modo assinatura
    var pagseguro = require('pagseguro'),
        pag = new pagseguro({
            email : 'suporte@lojamodelo.com.br',
            token: '95112EE828D94278BD394E91C4388F20',
            mode : 'sandbox'
        });
```

É preciso gerar um token específico para o modo Sandbox na [Página do Sandbox do PagSeguro](https://sandbox.pagseguro.uol.com.br)

## Changelog

* **v0.1.0** - Assinaturas no PagSeguro
    - Novo construtor aceita um objeto de configuração ao invés dos argumentos de e-mail e token. A maneira antiga ainda é válida, mas está obsoleta e gerará um aviso no console.
    - A configuração aceita três modos de pagamento (atributo `mode`):
        + `'payment'` : Pagamento único padrão do PagSeguro (**Padrão**)
        + `'subscription'` : Modo de assinatura para pagamentos recorrentes
        + `'sandbox'` : Modo de testes do PagSeguro (ver https://sandbox.pagseguro.uol.com.br/)
    - Nova função para configurar assinaturas: `pag.preApproval(config)`
    - Caso a função `addItem()` seja chamada em modo `subscription`, é levantada uma exceção
    - Caso a função `preApproval()` seja chamada em modo `payment` ou `sandbox`, é levantada uma exceção
    - Caso a função `setReviewURL()` seja chamada em modo `payment` ou `sandbox`, é levantada uma exceção
