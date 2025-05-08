var express = require('express');
var router = express.Router();

router.get('/', async function(req, res, next) {

    let payments = await req.db.any(`
        SELECT
            payments.id AS id,
            orders.label AS order_label,
            payment_types.label AS payment_type_label,
            payments.amount AS amount
        FROM
            payments
        INNER JOIN
            payment_types ON payment_types.id = payments.id_payment_type
        INNER JOIN
            orders ON orders.id = payments.id_order
    `)
    console.log(payments)
    res.render('payments/list', { title: 'Платежи', payments: payments })

});

module.exports = router;
