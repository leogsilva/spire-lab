const Kafka = require("node-rdkafka"); // see: https://github.com/blizzard/node-rdkafka
const externalConfig = require('./config');
const ERR_TOPIC_ALREADY_EXISTS = 36;
const kafkaConf = {
    ...externalConfig.kafkaConfig
    , ...{
        "socket.keepalive.enable": true,
        "debug": "generic,broker,security"
    }
};


function ensureTopicExists(config, topic) {
    const adminClient = Kafka.AdminClient.create({
      'bootstrap.servers': config['metadata.broker.list'],
      'sasl.username': config['sasl.username'],
      'sasl.password': config['sasl.password'],
      'security.protocol': config['security.protocol'],
      'sasl.mechanisms': config['sasl.mechanisms']
    });
  
    return new Promise((resolve, reject) => {
      adminClient.createTopic({
        topic: topic,
        num_partitions: 1,
        replication_factor: 3
      }, (err) => {
        if (!err) {
          console.log(`Created topic ${topic}`);
          return resolve();
        }
  
        if (err.code === ERR_TOPIC_ALREADY_EXISTS) {
          return resolve();
        }
  
        return reject(err);
      });
    });
  }

function createProducer(config, onDeliveryReport) {
    const producer = new Kafka.Producer({
        'bootstrap.servers': config['metadata.broker.list'],
        'sasl.username': config['sasl.username'],
        'sasl.password': config['sasl.password'],
        'security.protocol': config['security.protocol'],
        'sasl.mechanisms': config['sasl.mechanisms'],
        'dr_msg_cb': true
    });

    return new Promise((resolve, reject) => {
        producer
        .on('ready', () => resolve(producer))
        .on('delivery-report', onDeliveryReport)
        .on('event.error', (err) => {
            console.warn('event.error', err);
            reject(err);e
        });
        producer.connect();
    });
}

exports.myProduceExample =  async function (body) {
    await ensureTopicExists(kafkaConf, body.topic);
    
    const producer = await createProducer(kafkaConf, (err, report) => {
        if (err) {
        console.warn('Error producing', err)
      } else {
        const {topic, partition, value} = report;
        console.log(`Successfully produced record to topic "${topic}" partition ${partition} ${value}`);
      }
    });
    const message = Buffer.from(JSON.stringify({message: body.message}));
    //const message = body.message;
    const key = 1;
    producer.produce(body.topic, -1, message, key);
  
    producer.flush(10000, () => {
      producer.disconnect();
    });
  }