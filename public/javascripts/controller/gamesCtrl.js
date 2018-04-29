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
            gameNumber: 0,
            totalBets: 0,
            pool: 0,
            redPool: 0,
            redBets: [],
            blackPool: 0,
            blackBets: [],
            poolFee: 0
        };
        var contractInstance;

        window.redBlackContract.deployed().then(function(instance) {
            contractInstance = instance;
            isGameRunning(instance);
            getPoolStat(instance);
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

        function getTotalBets(instance) {
            instance.ticketCounter().then(function(totalBets) {
                $scope.$apply(function () {
                    $scope.colorGame.totalBets = totalBets.toNumber();
                });
            }).catch(function(err) {
                console.error(err);
            });
        }

        function getTotalPool(instance) {
            instance.totalBettingAmountColorGame().then(function(totalPool) {
                $scope.$apply(function () {
                    $scope.colorGame.pool = web3.fromWei(totalPool, "ether").toNumber();
                });
            }).catch(function(err) {
                console.error(err);
            });
        }

        function getRedPool(instance) {
            instance.colorTotalAmount(0).then(function(redPool) {
                $scope.$apply(function () {
                    $scope.colorGame.redPool = web3.fromWei(redPool, "ether").toNumber();
                });
            }).catch(function(err) {
                console.error(err);
            });
        }

        function getBlackPool(instance) {
            instance.colorTotalAmount(1).then(function(blackPool) {
                $scope.$apply(function () {
                    $scope.colorGame.blackPool = web3.fromWei(blackPool, "ether").toNumber();
                });
            }).catch(function(err) {
                console.error(err);
            });
        }

        function getPoolFee(instance) {
            instance.getPoolFee().then(function(fee) {
                $scope.$apply(function () {
                    $scope.colorGame.poolFee = web3.fromWei(fee, "ether").toNumber();
                });
            }).catch(function(err) {
                console.error(err);
            });
        }

        function getUserBets(instance) {
            window.web3.eth.getCoinbase(function(err, account){
                instance.getBetterDetailsByAddress(account).then(function(betIds) {
                    $scope.colorGame.redBets = [];
                    $scope.colorGame.blackBets = [];
                    for(var i = 0; i < betIds.length; i++) {
                        var betId = betIds[i];
                        instance.bets(betId.toNumber()).then(function(userBet){
                            $scope.$apply(function () {
                                if(userBet[1] == "RED"){
                                    $scope.colorGame.redBets.push({value: web3.fromWei(userBet[2], "ether").toNumber()})
                                } else{
                                    $scope.colorGame.blackBets.push({value: web3.fromWei(userBet[2], "ether").toNumber()})
                                }
                            });
                        });
                    }
                }).catch(function(err) {
                    console.error(err);
                });
            });
        }

        function getPoolStat(instance) {
            getTotalBets(instance);
            getTotalPool(instance);
            getRedPool(instance);
            getBlackPool(instance);
            getPoolFee(instance);
            getUserBets(instance);
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
