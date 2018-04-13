'use strict';

/**
 *
 * @name InsuredCtrl
 * @description
 * # protchain InsuredCtrl
 *
 * Insured Controller of the application.
 */
var protchainApp = angular.module('protchainApp');

protchainApp.controller('InsuredCtrl', ['$scope', '$http', '$location', '$rootScope', '$routeParams',
    function ($scope, $http, $location, $rootScope, $routeParams) {
        var priceRange = ["0-250", "250-750", "750-1000", "1000-1500"];
        $scope.user = {
            name: null,
            lastname: null
        };
        $scope.device = {
            make: $routeParams.make,
            model: $routeParams.model,
            devicePrice: priceRange[$routeParams.price],
            devicePriceIndex: $routeParams.price,
            term: $routeParams.term,
            insurancePrice: $routeParams.quote
        };

        $scope.insured = function () {
            console.log("Insured name:" + $scope.user.name + " last name:" + $scope.user.lastname);
            window.web3.eth.getCoinbase(function(err, account) {
                if (err === null) {
                    var price = web3.toWei($scope.device.insurancePrice, "ether");
                    window.protchainContract.deployed().then(function(instance) {
                        return instance.buyInsurance(
                            $scope.user.name,
                            $scope.user.lastname,
                            $scope.device.make,
                            $scope.device.model,
                            $scope.device.term,
                            $scope.device.devicePriceIndex,
                            price,
                            {from: account, value: price, gas: 500000}
                            );
                    }).then(function(result) {
                        window.location.href = '/';
                    }).catch(function(err) {
                        console.error(err);
                    });
                }
            });

        }
    }]);