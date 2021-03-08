var ProducerKafkaMsg = require('./producer');
var ConsumerKafkaMsg = require('./consumer');
var bodyParser = require('body-parser');

exports.post = (req, res, next) => {
  let message = req.params.message;
  
   
  ProducerKafkaMsg.myProduceExample(req.body);
   res.status(201).json({});
   
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
 
exports.getById = async (req, res, next) => {
   let id = req.params.id;
   
   var result = {
      msg: []
   };
   
   
   let p = await  ConsumerKafkaMsg.myConsumerExample(id, function(msgs){
      result.msg = msgs;
      console.log("passou aqui!");
   });
   
   res.status(200).json(result);
};


