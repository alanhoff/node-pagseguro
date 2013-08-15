node-pagseguro
==============

Integração ao Pagseguro para sistemas usando o Node.js

Instalação
----------

`npm install pagseguro`

Como usar
---------
```javascript
    //Inicializar a função com o e-mail e token
    var pag, pagseguro;
    pagseguro = require('pagseguro');
    pag = new pagseguro('suporte@lojamodelo.com.br', '95112EE828D94278BD394E91C4388F20');

    //Configurando a moeda e a ferência do pedido
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