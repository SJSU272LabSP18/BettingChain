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
            .when('/insured', {
                templateUrl: 'views/insured.html',
                controller: 'InsuredCtrl'
            })
            .otherwise({
                redirectTo: '/dashboard'
            });
    });

