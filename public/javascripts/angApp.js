'use strict';

/**
 *
 * @name protchainApp
 * @description
 * # protchainApp
 *
 * Main module of the application.
 */
angular
    .module('protchainApp', [
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
            .otherwise({
                redirectTo: '/dashboard'
            });
    });

