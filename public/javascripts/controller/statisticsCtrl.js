var app = angular.module('lotterApp', []);



app.controller('statisticsCtrl', function($scope, $http) {
   window.web3.eth.getCoinbase(function(err, account){
                instance.getBetterDetailsByAddress(account).then(function(betIds) {
    
    	$scope.names = betIds;
});