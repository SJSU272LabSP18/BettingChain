'use strict';

var protchainContract = require('../contract/Protchain.js');
var truffle = require('truffle-contract');

module.exports.init = function(){

    var contract = truffle(protchainContract);

    return contract;
};