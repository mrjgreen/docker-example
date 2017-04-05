const router = require('node-async-router')();
const TodoRepository = require('./todo/repository');

const todo = new TodoRepository(process.env.REDIS_HOST, process.env.REDIS_PORT);

router.get('/status', (req, res) => {
  res.json({ message: 'OK' });
});

router.get('/health_check', async (req, res) => {
  res.json({data: await todo.ping(), message: 'OK' });
});

// Todo Items
router.get('/api/items', async (req, res, next) => {
  const data = await todo.getItems();
  res.json(data);
});

router.post('/api/items', async (req, res) => {
  const item = await todo.createItem(req.body);
  res.json(item);
});

router.delete('/api/items/:itemId', async (req, res) => {
  await todo.deleteItem(req.params.itemId);
  res.json({message: 'OK'});
});

router.put('/api/items/:itemId/complete', async (req, res) => {
  if(req.body.status) {
    await todo.completeItem(req.params.itemId);
  } else {
    await todo.todoItem(req.params.itemId);
  }
  res.json({message: 'OK'});
});

module.exports = router;
