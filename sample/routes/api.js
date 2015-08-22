var pagseguro = require('pagseguro');
var data= [];
var pag= new pagseguro({
        email : 'sample@uol.com',
        token: 'DD98D6DE3D724489883F3D1F24ED8EDA'
    });

//Configurando a moeda e a referência do pedido
pag.currency('BRL');
pag.reference('12345');



// POST

exports.checkOut= function(req, res) {
	
	//adicionar os produtos no carrinho
	req.body.forEach(function (item, i) {
		pag.addItem({
	        id: item.id,
	        description: item.name,
	        amount: item.price,
	        quantity: 1,
	        weight: 10.1
	    });
	});

	//Configurando as informações do comprador
    pag.buyer({
        name: 'Emerson jose',
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
}

