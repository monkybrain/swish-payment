# Library for Swish Handel API

Uses promises for async operations

## Install

`npm install swish-payment`

## Use

`swish = require('swish-payment')`

## Methods

Library contains only three methods:
- init
- add
- get

See reference below.

### init(options)

Initialize Swish module.

Takes _options object_ (see below) as argument. Resolves with _options object_ if successful.

Must be called before adding and getting payments.

Convert provided .p12 to .pem before use (with OPENSSL or equivalent).

```
# OPTION OBJECT
{
  cert: {
    key: <STRING>         # Path to .pem file containing private key
    cert: <STRING>        # Path to .pem file containing SSL certificate
    ca: <STRING>          # Path to .pem file containing root certificate
    passphrase: <STRING>  # Passphrase for private key
  },
  data: {
    payeeAlias <STRING>   # Merchant Swish number
    currency: <STRING>    # Currency code (default: "SEK")
    callbackUrl: <STRING> # Callback URL for payment request status notification
  }
}
```

_Example_
```
swish.init({
  cert: {
    key: 'res/certs/swish.key',
    cert: 'res/certs/swish.crt',
    ca: 'res/certs/swish.ca',
    passphrase: 'swish'
  },
  data: {
    payeeAlias: '1231181189',
    currency: 'SEK',
    callbackUrl: 'https://www.minsida.se/callback'
  }
});
```

### add(data)

Send payment request to Swish.

Takes _data object_ (see below) as argument. Resolves with Swish payment ID if successful.

```
# DATA OBJECT
{
  payeePaymentReference: <STRING>   # Merchant payment reference (e.g. order id)
  payerAlias: <STRING>              # Telephone number of customer
  amount: <STRING>                  # Amount in SEK (e.g. "100" or "49.50")
  message: <STRING>                 # Merchant supplied message to customer
}
```

_Example_
```
  swish.add({
    payeePaymentReference: "snus123",
    payerAlias: '0706123456',
    amount: "100",
    message: "Prima snus"
  })
  .then(function(id) {
    console.log(id);      # e.g. "DE6F11C3A0AF4AFC9399C0F0ECC50C5E"
  });
```

### get(id)

Get payment data by ID.

Takes Swish payment ID as argument and resolves with payment data if successful.

_Example_
```
swish.get('DE6F11C3A0AF4AFC9399C0F0ECC50C5E')
.then(function(data) {
  console.log(data);
});

# Example response
{ errorCode: null,
  errorMessage: null,
  id: 'DE6F11C3A0AF4AFC9399C0F0ECC50C5E',
  payeePaymentReference: 'snus123',
  paymentReference: '5504E033FA7E4C85B7B2C9C7947D9C5D',
  callbackUrl: 'https://www.test.se/callback',
  payerAlias: '0706123456',
  payeeAlias: '1231181189',
  amount: 100,
  currency: 'SEK',
  message: 'Prima snus',
  status: 'PAID',
  dateCreated: '2016-06-03T13:20:26.093Z',
  datePaid: '2016-06-03T13:20:26.094Z' }
```
