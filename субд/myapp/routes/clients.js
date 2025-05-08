var express = require('express');
var router = express.Router();

router.get('/', async function(req, res, next) {

    let clients = await req.db.any(`
        SELECT
            *
        FROM
            clients
    `)
    console.log(clients)
    res.render('clients/list', { title: 'Клиенты', clients: clients })

});

module.exports = router;
