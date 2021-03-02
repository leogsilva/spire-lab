var ProducerKafkaMsg = require('./producer');
var bodyParser = require('body-parser');

exports.post = (req, res, next) => {
  // let message = req.params.message;
  //await( ProducerKafkaMsg.myProduceExample());
  console.log(req.body.topicName);
   
  ProducerKafkaMsg.myProduceExample(req.body);
   res.status(201).send('Agora vai!');
};
 
exports.put = (req, res, next) => {
   let id = req.params.id;
   res.status(201).send(`Rota PUT com ID! --> ${id}`);
};
 
exports.delete = (req, res, next) => {
   let id = req.params.id;
   res.status(200).send(`Rota DELETE com ID! --> ${id}`);
};
 
exports.get = (req, res, next) => {
   res.status(200).send('Rota GET!');
};
 
exports.getById = (req, res, next) => {
   let id = req.params.id;
   res.status(200).send(`Rota GET com ID! ${id}`);
};
