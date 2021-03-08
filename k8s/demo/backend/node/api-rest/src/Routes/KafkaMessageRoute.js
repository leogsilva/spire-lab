const KafkaMessageController = require('../Controllers/KafkaMessageController');

module.exports = (app) => {
   app.post('/message', KafkaMessageController.post);
   app.put('/message/:id', KafkaMessageController.put);
   app.delete('/message/:id', KafkaMessageController.delete);
   app.get('/messages', KafkaMessageController.get);
   app.get('/message/:id', KafkaMessageController.getById);

}
