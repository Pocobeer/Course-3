var express = require('express');
var router = express.Router();

// Добавляем middleware для проверки числовых ID
const validateId = (req, res, next) => {
    const id = parseInt(req.params.id);
    if (isNaN(id) || id <= 0) {
      return res.status(400).json({ error: 'Invalid ID format' });
    }
    req.validId = id;
    next();
  };
  

router.get('/', async function(req, res, next) {
    try {
        const orders = await req.db.any(`
            SELECT
                orders.id,
                orders.label,
                order_statuses.label AS order_status_label,
                clients.label AS client_label,
                orders.amount
            FROM orders
            INNER JOIN clients ON clients.id = orders.id_client
            INNER JOIN order_statuses ON order_statuses.id = orders.id_status
            LIMIT 100
        `);
        
        const clients = await req.db.any('SELECT id, label FROM clients LIMIT 100');
        
        res.render('orders/list', { 
            title: 'Заказы', 
            orders: orders, 
            clients: clients 
        });
    } catch (error) {
        console.error('Database error:', error);
        next(error);
    }
});

router.post('/create', async function(req, res, next) {
    try {
        const { label, id_client, amount } = req.body;
        
        if (!label || !id_client || !amount) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
        
        // Двойная проверка типов
        const clientId = parseInt(id_client);
        const orderAmount = parseFloat(amount);
        
        if (isNaN(clientId) || isNaN(orderAmount)) {
            return res.status(400).json({ error: 'Invalid data types' });
        }
        
        await req.db.none(
            'INSERT INTO orders(label, id_client, amount) VALUES($1, $2, $3)', 
            [label, clientId, orderAmount]
        );
        
        res.json({ success: true });
    } catch (error) {
        console.error('Create error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.get('/orders/:id', validateId, async (req, res) => {
    try {
      // Используем строго типизированный параметр
      const order = await db.oneOrNone(
        `SELECT 
          o.id, o.label, 
          os.label AS status, 
          c.label AS client, 
          o.amount
         FROM orders o
         JOIN clients c ON c.id = o.id_client
         JOIN order_statuses os ON os.id = o.id_status
         WHERE o.id = $1`,
        [req.validId],
        // Дополнительная защита
        { capSQL: true }
      );
  
      if (!order) {
        return res.status(404).json({ error: 'Order not found' });
      }
  
      res.json(order);
    } catch (err) {
      console.error('SECURITY ERROR:', err);
      res.status(500).json({ error: 'Database operation failed' });
    }
  });

module.exports = router;