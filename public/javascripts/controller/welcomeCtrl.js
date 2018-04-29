'use strict';

/**
 *
 * @name WelcomeCtrl
 * @description
 * # lottery WelcomeCtrl
 *
 * Welcome Controller of the application.
 */
var lotteryApp = angular.module('lotteryApp');

lotteryApp.controller('WelcomeCtrl', ['$scope', '$http', '$location', '$rootScope', '$routeParams',
    function ($scope, $http, $location, $rootScope, $routeParams) {
        /*console.log("Contract:", window.protchainContract);
        $scope.balance = 0;
        var protchainInstance;
        window.protchainContract.deployed().then(function(instance){
            protchainInstance = instance;
            getPoolBalance(protchainInstance);
            getCurrentInsurance(protchainInstance);

            return protchainInstance.getNumberOfInsurances();
        }).then(function (insuranceIds) {
            var contracts = insuranceIds.c[0];
            $('#pool_contracts').text('pool contracts: ' + contracts);
            console.log("Contracts number:", contracts);

            for (var i = 1; i < contracts + 1; i++) {
                protchainInstance.insurances(i).then(function(insurance) {
                    console.log('insurance:', insurance);

                });
            }
        });

        $('#getInsured').addClass('disabled');
        $scope.deviceList = {
            makeList: [{id: 'iPhone', name: 'iPhone'}, {id: 'Samsung', name: 'Samsung'}],
            modelList:{
                iPhone: [{id: 'iph5', name: '5'}, {id: 'iph5s', name: '5s'}, {id: 'iph6', name: '6'}],
                Samsung: [{id: 'sam1', name: 'sam1'}, {id: 'sam2', name: 'sam2'}, {id: 'sam3', name: 'sam3'}]
            }
        };
        $scope.device = {
            make: 'iPhone',
            model: null,
            price: 0,
            term: 0
        };


        $scope.getQuote = function () {
            console.log("Device make:" + $scope.device.make + " model:" + $scope.device.model + " price:" + $scope.device.price + " term:" + $scope.device.term);
            var quoteByPrice = [20, 25, 30, 40];
            var quoteByModel = {iph5: 1.0, iph5s: 1.2, iph6: 1.3, sam1: 1.0, sam2: 1.1, sam3: 1.2};
            $scope.quote = quoteByPrice[$scope.device.price] * $scope.device.term * quoteByModel[$scope.device.model];
            $('#getQuote').prop("disabled",true);
            $('#getInsured').removeClass('disabled');
        };

        $scope.changeDevice = function(){
            console.log("Change device ...");
            $('#getQuote').prop("disabled",false);
            $scope.quote = null;
            $('#getInsured').addClass('disabled');
        };

        $scope.claim = function () {
            window.web3.eth.getCoinbase(function(err, account) {
                if (err === null) {
                    var price = web3.toWei($scope.device.insurancePrice, "ether");
                    window.protchainContract.deployed().then(function(instance) {
                        return instance.claim(account, {from: account, gas: 500000}
                        );
                    }).then(function(result) {
                        alert("Insurance was successfully claimed");
                    }).catch(function(err) {
                        console.error(err);
                    });
                }
            });
        };

        //Private functions

        function getPoolBalance(instance) {
            web3.eth.getBalance(instance.address, function(err, balance) {
                if (err === null) {
                    balance = web3.fromWei(balance, "ether") + " ETH";
                    $('#pool_balance').text('pool balance: ' + balance);
                    console.log('Balance:', balance);
                }
            });
        }

        function getCurrentInsurance(instance) {
            window.web3.eth.getCoinbase(function (err, account) {
                $('#account-address').text('address: ' + account);
                web3.eth.getBalance(account, function(err, balance) {
                    if (err === null) {
                        balance = web3.fromWei(balance, "ether") + " ETH";
                        $('#account-balance').text('balance: ' + balance);
                    }
                });

                if (err === null) {
                    instance.getInsuranceByAddress(account).then(function (insurance) {
                        if(insurance[0] != ""){
                            console.log('Current insurance:', insurance);
                            $('#card-title').text(insurance[2] + ' ' + insurance[3]);
                            $('#card-subtitle').text(insurance[0] + ' ' + insurance[1]);
                            $('#card-term-badge').text(insurance[4] + ' year');
                            $('#card-insurance-price-badge').text(web3.fromWei(insurance[6], "ether") + " ETH");
                            console.log("test:", insurance[8]);
                            if(insurance[8]){
                                $("#claim-btn").remove();
                                $('#card-insurance-claimed-badge').text('claimed');
                            }
                        } else {
                            $("#claim-btn").remove();
                        }

                    }).catch(function (err) {
                        console.error(err);
                    });
                }
            });
        }*/
    }]);