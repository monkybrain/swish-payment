# Library for Swish Handel API

Uses promises for async operations

## Install

`npm install swish-payment`

## Use

`swish = require('swish-payment')`

## Methods

### init (options)
Must be called before adding and getting payments. Convert .p12 cert to .pem before use.

- Takes: option object (see below)
- Resolves: config object
- Rejects: error

_option object_
- cert
  - key (string)
    - Path to .pem file containing public key
  - cert (string)
    - Path to .pem file containing certificate
  - ca (string)
    - Path to .pem file containing root certificate
  - passphrase (string)
    - Passphrase
- data
  - payeeAlias (string)
      - Merchant telephone number
  - currency (string)
    - Currency code (default "SEK")
  - callbackUrl (string)
    - Webhook URL for payment status updates (must be HTTPS)

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

### add (data)
Send payment request to Swish.

- Takes: data object (see below)
- Resolves: payment ID
- Rejects: error

_data object_

- payeePaymentReference (string)
  - Merchant reference
- payerAlias (string)
  - Customer telephone number
- amount (string)
  - Payment amount in SEK
- message (string)
  - Message presented to customer

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

### get (id)

- Takes: payment ID
- Resolves: payment data
- Rejects: error

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
