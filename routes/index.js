var express = require('express');
var router = express.Router();


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

/*router.post('/admin',passport.authenticate('local', { successRedirect: '/admin-page',
    failureRedirect: '/admin',
    failureFlash: true })
);*/

module.exports = router;
