'use strict';

/**
 *
 * @name GamesCtrl
 * @description
 * # lottery GamesCtrl
 *
 * Insured Controller of the application.
 */
var lotteryApp = angular.module('lotteryApp');

lotteryApp.controller('GamesCtrl', ['$scope', '$http', '$location', '$rootScope', '$routeParams',
    function ($scope, $http, $location, $rootScope, $routeParams) {
        $scope.colorGame = {
            color: "",
            eth: 0,
            gameNumber: 0
        };

        window.redBlackContract.deployed().then(function(instance) {
            isGameRunning(instance);
            return instance.gameNumber();
        }).then(function(gameNumber) {
            $scope.$apply(function () {
                $scope.colorGame.gameNumber = gameNumber.toNumber();
            });
        }).catch(function(err) {
            console.error(err);
        });

        /** Public functions **/

        $scope.redBet = function () {
            //here should be logic to highlight red square
            $scope.colorGame.color = "RED";
        };

        $scope.blackBet = function () {
            //here should be logic to highlight black square
            $scope.colorGame.color = "BLACK";
        };

        $scope.makeBetForColorGame = function () {
            if($scope.colorGame.color == ""){
                window.alert("Please choose the color");
                return;
            }
            if($scope.colorGame.eth < 1){
                window.alert("Please make a bet equal or more 1 eth");
                return;
            }
            window.web3.eth.getCoinbase(function(err, account) {
                if (err === null) {
                    var price = web3.toWei($scope.colorGame.eth, "ether");
                    window.redBlackContract.deployed().then(function(instance) {
                        return instance.insert_bet_color($scope.colorGame.color, {from: account, value: price, gas: 500000});
                    }).then(function(result) {
                        window.alert("Your Bet was accepted color:" + $scope.colorGame.color + " eth:" + $scope.colorGame.eth);
                        resetColorGame();
                    }).catch(function(err) {
                        console.error(err);
                    });
                }
            });
        };


        /** Private functions **/

        function resetColorGame(){
            console.log("scope", $scope);
            $scope.$apply(function () {
                $scope.colorGame.color = "";
                $scope.colorGame.eth = 0;
            });
            //reset color square highlight
        }

        function isGameRunning(instance) {
            instance.isGameRunning().then(function(isGameRunning) {
                if(isGameRunning){
                    $("#active-span").removeClass("invisible");
                    $("#inactive-span").addClass("invisible");
                    $("#makeBetColorGameBtn").removeAttr("disabled");
                } else {
                    $("#active-span").addClass("invisible");
                    $("#inactive-span").removeClass("invisible");
                }
            }).catch(function(err) {
                console.error(err);
            });
        }
    }
]);




/*
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
    console.log("The bit was made:" + $scope.user.name + " last name:" + $scope.user.lastname);
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

}*/
