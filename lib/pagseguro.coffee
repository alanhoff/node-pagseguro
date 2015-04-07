xml = require('jstoxml');

req = require('request');

class pagseguro
    constructor: (configObj) ->
        if arguments.length > 1
            @email = arguments[0]
            @token = arguments[1]
            @mode = "payment"
            console.warn "This constructor is deprecated. Please use a
 single object with the config options as attributes"
        else
            @email = configObj.email
            @token = configObj.token
            @mode = configObj.mode or "payment"
        @obj = {}
        @xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        return this

    currency: (cur) ->
        @obj.currency = cur;
        @

    reference: (ref) ->
        @obj.reference = ref;
        @

    addItem: (item) ->
        if @mode is 'subscription'
            throw new Error "This function is for payment mode only!"
        @obj.items = [] if not @obj.items?
        @obj.items.push item:item
        @

    buyer: (buyer) ->
        @obj.sender =
            name : buyer.name
            email : buyer.email
            phone :
                areaCode : buyer.phoneAreaCode
                number : buyer.phoneNumber

        if @mode is 'subscription'
            @obj.sender.address = {}

            @obj.sender.address.street = buyer.street if buyer.street?
            @obj.sender.address.number = buyer.number if buyer.number?
            @obj.sender.address.postalCode = buyer.postalCode if buyer.postalCode?
            @obj.sender.address.city = buyer.city if buyer.city?
            @obj.sender.address.state = buyer.state if buyer.state?
            @obj.sender.address.country = buyer.country if buyer.country?
            @obj.sender.address.complement = buyer.complement if buyer.complement?
            @obj.sender.address.district = buyer.district if buyer.district?
        @

    shipping: (shippingInfo) ->
        switch @mode
            when 'payment', 'sandbox'
                @obj.shipping =
                    type : shippingInfo.type
                    address :
                        street : shippingInfo.street
                        number : shippingInfo.number
                        postalCode : shippingInfo.postalCode;
                        city : shippingInfo.city;
                        state : shippingInfo.state;
                        country : shippingInfo.country;

                @obj.shipping.complement = shippingInfo.complement if shippingInfo.complement?
                @obj.shipping.district = shippingInfo.district if shippingInfo.district?
            when 'subscription'
                @obj.sender = {} if not @obj.sender?
                @obj.sender.address =
                    street : shippingInfo.street
                    number : shippingInfo.number
                    postalCode : shippingInfo.postalCode;
                    city : shippingInfo.city;
                    state : shippingInfo.state;
                    country : shippingInfo.country;

                @obj.sender.address.complement = shippingInfo.complement if shippingInfo.complement?
                @obj.sender.address.district = shippingInfo.district if shippingInfo.district?
        @

    # Termos da assinatura
    preApproval: (preApprovalInfo) ->
        if @mode is 'subscription'
            twoYearsFromNow = new Date()
            twoYearsFromNow.setFullYear twoYearsFromNow.getFullYear()+2
            maxTotalAmount = preApprovalInfo.maxTotalAmount*1 or
                preApprovalInfo.amountPerPayment*24 or
                preApprovalInfo.maxAmountPerPayment*24

            @obj.preApproval =
                charge : preApprovalInfo.charge or 'manual' #'auto' or 'manual'
                finalDate : preApprovalInfo.finalDate or twoYearsFromNow.toJSON() # Max 2 anos
                maxTotalAmount : maxTotalAmount.toFixed 2

            @obj.preApproval.name = preApprovalInfo.name if preApprovalInfo.name?
            @obj.preApproval.details = preApprovalInfo.details if preApprovalInfo.details?
            @obj.preApproval.period = preApprovalInfo.period if preApprovalInfo.period?
            @obj.preApproval.amountPerPayment = preApprovalInfo.amountPerPayment if preApprovalInfo.amountPerPayment?
            @obj.preApproval.maxAmountPerPayment = preApprovalInfo.maxAmountPerPayment if preApprovalInfo.maxAmountPerPayment?
            @obj.preApproval.maxPaymentsPerPeriod = preApprovalInfo.maxPaymentsPerPeriod if preApprovalInfo.maxPaymentsPerPeriod?
            @obj.preApproval.maxAmountPerPeriod = preApprovalInfo.maxAmountPerPeriod if preApprovalInfo.maxAmountPerPeriod?
            @obj.preApproval.initialDate = preApprovalInfo.initialDate if preApprovalInfo.initialDate?
        else
            throw new Error "This function is for subscription mode only!"
        @
    ###
    Configura as URLs de retorno e de notificação por pagamento
    ###
    setRedirectURL: (url) ->
        @obj.redirectURL = url;
        @

    setNotificationURL: (url) ->
        @obj.notificationURL = url;
        @

    # Configura URL de revisão dos termos de assinatura
    setReviewURL: (url) ->
        if @mode is "subscription"
            @obj.reviewURL = url;
        else
            throw new Error "This function is for subscription mode only!"
        @

    send: (callback) ->
        options =
            method: 'POST'
            headers:
                'Content-Type': 'application/xml; charset=UTF-8'

        switch @mode
            when 'payment'
                options.uri = "https://ws.pagseguro.uol.com.br/v2/checkout?email=#{@email}&token=#{@token}"
                options.body = @xml + xml.toXML checkout:@obj
            when 'subscription'
                options.uri = "https://ws.pagseguro.uol.com.br/v2/pre-approvals/request?email=#{@email}&token=#{@token}"
                options.body = @xml + xml.toXML preApprovalRequest:@obj
            when 'sandbox'
                options.uri = "https://ws.sandbox.pagseguro.uol.com.br/v2/checkout?email=#{@email}&token=#{@token}"
                options.body = @xml + xml.toXML checkout:@obj

        return req options, (err, res, body) ->
            if err
                callback err
            else
                callback null,body

module.exports = pagseguro;
