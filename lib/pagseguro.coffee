xml = require('jstoxml');

req = require('request');

class pagseguro
    constructor: (@email, @token) ->
        this.obj = new Object
        this.xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        return this
        
    currency: (cur) ->
        this.obj['currency'] = cur;
        return this;
        
    reference: (ref) ->
        this.obj['reference'] = ref;
        return this;
        
    addItem: (item) ->
        if !this.obj['items']
          this.obj['items'] = new Array;
        
        this.obj.items.push({
          item: item
        });
        return this;
        
    buyer: (obj) ->
        this.obj['sender'] = new Object;
        this.obj.sender['name'] = obj.name;
        this.obj.sender['email'] = obj.email;
        this.obj.sender['phone'] = new Object;
        this.obj.sender.phone['areaCode'] = obj.phoneAreaCode;
        this.obj.sender.phone['number'] = obj.phoneNumber;
        return this;
        
    shipping: (obj) ->
        this.obj['shipping'] = new Object;
        this.obj.shipping['type'] = obj.type;
        this.obj.shipping['address'] = new Object;
        this.obj.shipping.address['street'] = obj.street;
        this.obj.shipping.address['number'] = obj.number;
        if obj.complement 
          this.obj.shipping.address['complement'] = obj.complement;
        
        if obj.district
          this.obj.shipping.address['district'] = obj.district;
        
        this.obj.shipping.address['postalCode'] = obj.postalCode;
        this.obj.shipping.address['city'] = obj.city;
        this.obj.shipping.address['state'] = obj.state;
        this.obj.shipping.address['country'] = obj.country;
        return this;

    ###
    Configura as URLs de retorno e de notificação por pagamento
    ###
    setRedirectURL: (url) ->
        this.obj.redirectURL = url;
        return this;

    setNotificationURL: (url) ->
        this.obj.notificationURL = url;
        return this;

    send: (callback) ->
        options = {
            uri: "https://ws.pagseguro.uol.com.br/v2/checkout?email=" + this.email + "&token=" + this.token,
            method: 'POST',
            headers: {
                'Content-Type': 'application/xml; charset=UTF-8'
            },
         
        body: this.xml + xml.toXML({
            checkout: this.obj
        })
        };
        
        return req(options, (err, res, body) -> 
            callback(err) if err
            callback(null, body) if !err
        );

module.exports = pagseguro;