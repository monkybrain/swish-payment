# Library for Swish Handel API

Uses promises for async operations

## Methods

### init (options)
Must be called before adding and getting payments.

- Takes: option object (see below)
- Resolves: config object
- Rejects: error

_option object_
- cert
  - key (required)
    - Path to .pem file containing private key
    - type: STRING
  - cert (required)
    - Path to .pem file containing certificate
    - type: STRING
  - ca (required)
    - Path to .pem file containing root certificate
    - type: STRING
  - passphrase (required)
    - Private key passphrase
- data
  - payeeAlias (required)
      - Merchant telephone number
      - type: STRING
  - currency (optional)
    - Currency code
    - type: STRING
    - default: "SEK"
  - callbackUrl (required)
    - Webhook URL for payment status updates (must be HTTPS)
    - type: STRING

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

- payeePaymentReference (required)
  - Merchant reference
  - type: STRING
- payerAlias (required)
  - Customer telephone number
  - type: STRING
- amount (required)
  - Payment amount in SEK
  - type: STRING
- message (required)
  - Message presented to customer
  - type: STRING

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
  console.log(id);      # e.g. "DE6F11C3A0AF4AFC9399C0F0ECC50C5E"
});
```
