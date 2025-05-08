var express = require('express');
var router = express.Router();


router.get('/', function(req, res, next) {

    let user = session.auth(req).user
    let can = session.can(user)

    res.render('index', {
        title:  "ИС",
        user:   user,
        can: can,
    })


});

module.exports = router;
