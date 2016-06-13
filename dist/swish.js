var Promise, R, config, fs, request, urls;

Promise = require("promise");

request = require("request");

R = require('ramda');

fs = require("fs");

urls = {
  payment: "https://mss.swicpc.bankgirot.se/swish-cpcapi/api/v1/paymentrequests/",
  refund: "https://mss.swicpc.bankgirot.se/swish-cpcapi/api/v1/refunds/"
};

config = null;

exports.init = (function(_this) {
  return function(data) {
    return new Promise(function(resolve, reject) {
      return resolve(config = {
        cert: {
          key: fs.readFileSync(data.key, 'ascii'),
          cert: fs.readFileSync(data.cert, 'ascii'),
          ca: fs.readFileSync(data.ca, 'ascii'),
          passphrase: data.passphrase
        },
        data: {
          payeeAlias: data.payeeAlias,
          currency: (data != null ? data.currency : void 0) != null ? data.currency : "SEK",
          callbackUrl: data.callbackUrl
        }
      });
    });
  };
})(this);

exports.get = function(id) {
  return new Promise(function(resolve, reject) {
    var options;
    options = R.merge(config.cert, {
      method: 'get',
      url: urls.payment + id
    });
    return request(options, function(err, response) {
      if (response.statusCode === 200) {
        return resolve(JSON.parse(response.body));
      } else {
        return reject({
          code: response.statusCode,
          message: response.statusMessage
        });
      }
    });
  });
};

exports.add = function(data) {
  return new Promise(function(resolve, reject) {
    var options;
    options = R.merge(config.cert, {
      method: 'post',
      url: urls.payments,
      body: R.merge(config.data, data),
      json: true
    });
    return request(options, function(err, response) {
      var location, ref, ref1;
      location = response != null ? (ref = response.caseless) != null ? (ref1 = ref.dict) != null ? ref1.location : void 0 : void 0 : void 0;
      if (location) {
        return resolve(location.slice(location.lastIndexOf('/') + 1));
      } else {
        return reject((response != null ? response.body : void 0) != null ? response.body : {
          err: "unknown"
        });
      }
    });
  });
};
