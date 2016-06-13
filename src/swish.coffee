Promise = require "promise"
request = require "request"
R = require 'ramda'
fs = require "fs"

urls =
  payment: "https://mss.swicpc.bankgirot.se/swish-cpcapi/api/v1/paymentrequests/"
  refund: "https://mss.swicpc.bankgirot.se/swish-cpcapi/api/v1/refunds/"

config = null

exports.init = (data) =>
  new Promise (resolve, reject) =>
    resolve config =
      cert:
        key: fs.readFileSync data.key, 'ascii'
        cert: fs.readFileSync data.cert, 'ascii'
        ca: fs.readFileSync data.ca, 'ascii'
        passphrase: data.passphrase
      data:
        payeeAlias: data.payeeAlias
        currency: if data?.currency? then data.currency else "SEK"
        callbackUrl: data.callbackUrl

# GET payment (GET)
exports.get = (id) ->

  # New promise
  new Promise (resolve, reject) ->

    # Request options (merged with certificates)
    options = R.merge config.cert,
      method: 'get'
      url: urls.payment + id

    # Send request
    request options, (err, response) ->

      # If request 200/OK -> return payment data
      if response.statusCode is 200 then resolve JSON.parse response.body

      # Else -> return error object
      else reject code: response.statusCode, message: response.statusMessage



# ADD payment (POST)
exports.add = (data) ->

  # New promise
  new Promise (resolve, reject) ->

    # Request options (merged with certificates)
    options = R.merge config.cert,
      method: 'post'
      url: urls.payments
      body: R.merge config.data, data
      json: true

    # Send request
    request options, (err, response) ->

      # Get URL from reponse
      location = response?.caseless?.dict?.location

      # If URL exists -> extract payment ID and resolve
      if location then resolve location.slice location.lastIndexOf('/') + 1

      # Else -> reject with error
      else reject if response?.body? then response.body else err: "unknown"
