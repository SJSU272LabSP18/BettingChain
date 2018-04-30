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
            .when('/admin', {
                templateUrl: 'views/admin.html',
                controller: 'AdminCtrl'
            })

            .when('/admin-page', {
                templateUrl: 'views/admin-page.html',
                controller: 'AdminpageCtrl'

})
            .when('/AdmLogin', {
                templateUrl: 'views/AdmLogin.html',
                controller: 'AdmLoginCtrl'

            })
            .otherwise({
                redirectTo: '/dashboard'
            });
    });

