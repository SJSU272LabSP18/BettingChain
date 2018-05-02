var express = require('express');
var router = express.Router();
var passport = require('passport');

var adminctrl = require('../src/controller/AdminCtrl')
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Astrum Lottery' });
});

router.get('/getInsured', function(req, res, next) {
    res.render('getInsured', { device:  req.param("device")});
});

router.post('/getQuote', function(req, res, next) {
    res.render('getQuote', {
        price:  '50',
        device_model: req.param('device_model'),
        device_price: req.param('device_price'),
        insurance_term: req.param('insurance_term'),
        theft_protection: req.param('theft_protection') != null?req.param('theft_protection'):'none'
    });
});

router.get('/rest/admin/stop/game', function(req, res){
    adminctrl.stopGame(req, res)
 
});

router.get('/rest/admin/start/game', function(req, res){
   
    adminctrl.startGame(req,res)
});

router.get('/rest/admin/select/players', function(req, res){
   
    adminctrl.selectPlayers(req,res)
});

router.get('/login',
    function(req, res){
        res.render('login');
    });

router.post('/login',
    passport.authenticate('local', { failureRedirect: '/login' }),
    function(req, res) {
        res.redirect('/admin');
    });

router.get('/logout',
    function(req, res){
        req.logout();
        res.redirect('/login');
    });

router.get('/admin',
    require('connect-ensure-login').ensureLoggedIn(),
    function(req, res){
        res.render('admin', { user: req.user });
    });
/*router.post('/admin',passport.authenticate('local', { successRedirect: '/admin-page',
    failureRedirect: '/admin',
    failureFlash: true })
);*/

module.exports = router;
