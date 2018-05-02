'use strict';

/**
 *
 * @name lotteryApp
 * @description
 * # lotteryApp
 *
 * Main module of the application.
 */
angular
    .module('lotteryApp', [
    //    'ngAnimate',
    //    'ngCookies',
        'ngResource',
        'ngRoute'
    ])
    .config(function ($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: 'views/welcome-page.html',
                controller: 'WelcomeCtrl'
            })
            .when('/game', {
                templateUrl: 'views/game.html',
                controller: 'GamesCtrl'
            })
            .when('/About-us',{
                templateUrl:'views/About-us.html'
                
            })
            .when('/statistics', {
                templateUrl: 'views/statistics.html',
                controller: 'statisticsCtrl'
            })

            .when('/admin-prof',{
                templateUrl:'views/admin-prof.html'
                
            })
            .otherwise({
                redirectTo: '/dashboard'
            });
    });

