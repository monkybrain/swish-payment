test = require 'tape'
async = require 'async'
swish = require '../dist/swish'

test "Successful flow (init -> add -> get)", (t) ->

  configData =
    key: 'res/certs/swish.key'
    cert: 'res/certs/swish.crt'
    ca: 'res/certs/swish.ca'
    passphrase: 'swish'
    payeeAlias: '1231181189'
    callbackUrl: 'https://www.test.se'

  # 1 - INIT
  swish.init configData
  .then (result) ->
    # 1 - Find private key
    t.notEqual -1, result.cert.key.search("BEGIN PRIVATE KEY"), "Found private key"
    # 2 - Find certificate
    t.notEqual -1, result.cert.cert.search("BEGIN CERTIFICATE"), "Found certificate"
    # 3 - Find root certificate
    t.notEqual -1, result.cert.ca.search("BEGIN CERTIFICATE"), "Found root certificate"
    # 4 - Find passphrase
    t.equal configData.passphrase, result.cert.passphrase, "Found passphrase"
    # 5 - Find payeeAlias
    t.equal configData.payeeAlias, result.data.payeeAlias, "Found payee alias"
    # 6 - Find payeeAlias
    t.equal configData.callbackUrl, result.data.callbackUrl, "Found callback url"

  # 2 - ADD
  .then ->

    paymentData =
      payeePaymentReference: "1234"
      payerAlias: '0709123456'
      amount: "100"
      message: "test"

    swish.add paymentData

  .then (@id) ->
    # 7 - Get id
    t.equal id.length, 32, "Response: 200 / valid ID (#{id})"
    swish.get id
  .then (result) ->
    console.log result
    t.equal id, result.id, "Response: 200 / found (#{id})"
    t.end()
  .catch (err) ->
    t.fail JSON.stringify error
    t.end()

# async.parallel tests
