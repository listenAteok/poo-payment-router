const PaymentRouter = artifacts.require("PaymentRouter");

module.exports = function (deployer, network) {
  var _token = null;
  var _recipient = null;
  if (network == 'eth') {
    _token = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    _recipient = '0x8c143a43AB69D6deB939328Fbc7fe67751052a3D';
  } else if (network == 'bnb') {
    _token = '0xe9e7cea3dedca5984780bafc599bd69add087d56';
    _recipient = '0xA31e17c2bf978794b861A06bcD71c88748d32D02';
  }  else if (network == 'avax') {
    _token = '0xc7198437980c041c805a1edcba50c1ce5db95118';
    _recipient = '0x8c143a43AB69D6deB939328Fbc7fe67751052a3D';
  }
  deployer.deploy(PaymentRouter, _token, _recipient);
};
