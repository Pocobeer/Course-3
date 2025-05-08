var express = require('express');
var router = express.Router();

router.get('/', async function(req, res, next) {

    let users = await req.db.any(`
        SELECT
            users.id AS id,
            users.login AS login,
            users.fio AS fio,
            roles.label AS role_label
        FROM
            users
        INNER JOIN roles ON roles.id = users.id_role
    `)
    console.log(users)
    res.json({users: users })

});

module.exports = router;