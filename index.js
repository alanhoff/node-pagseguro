var pagseguro, req, xml;

xml = require('jstoxml');

req = require('request');

pagseguro = (function() {

  pagseguro.name = 'pagseguro';

  function pagseguro(email, token) {
    this.email = email;
    this.token = token;
    this.obj = new Object;
    this.xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
    return this;
  }

  pagseguro.prototype.currency = function(cur) {
    this.obj['currency'] = cur;
    return this;
  };

  pagseguro.prototype.reference = function(ref) {
    this.obj['reference'] = ref;
    return this;
  };

  pagseguro.prototype.addItem = function(item) {
    if (!this.obj['itens']) {
      this.obj['itens'] = new Array;
    }
    this.obj.itens.push({
      item: item
    });
    return this;
  };

  pagseguro.prototype.buyer = function(obj) {
    this.obj['sender'] = new Object;
    this.obj.sender['name'] = obj.name;
    this.obj.sender['email'] = obj.email;
    this.obj.sender['phone'] = new Object;
    this.obj.sender.phone['areaCode'] = obj.phoneAreaCode;
    this.obj.sender.phone['number'] = obj.phoneNumber;
    return this;
  };

  pagseguro.prototype.shipping = function(obj) {
    this.obj['shipping'] = new Object;
    this.obj.shipping['type'] = obj.type;
    this.obj.shipping['address'] = new Object;
    this.obj.shipping.address['street'] = obj.street;
    this.obj.shipping.address['number'] = obj.number;
    if (obj.complement) {
      this.obj.shipping.address['complement'] = obj.complement;
    }
    if (obj.district) {
      this.obj.shipping.address['district'] = obj.district;
    }
    this.obj.shipping.address['postalCode'] = obj.postalCode;
    this.obj.shipping.address['city'] = obj.city;
    this.obj.shipping.address['state'] = obj.state;
    this.obj.shipping.address['country'] = obj.country;
    return this;
  };

  pagseguro.prototype.send = function(callback) {
    var options;
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
    return req(options, function(err, res, body) {
      if (err) {
        callback(err);
      }
      if (!err) {
        return callback(null, body);
      }
    });
  };

  return pagseguro;

})();
