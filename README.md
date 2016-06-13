# Library for Swish Handel API

Uses promises for async operations

## Methods

### init (options)
Must be called before adding payments.

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

### add (data)
Send payment request to Swish. Takes data object and resolves payment id och

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

### get (id)

- Takes: payment ID
- Resolves: payment data
- Rejects: error
