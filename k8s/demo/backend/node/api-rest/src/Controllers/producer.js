/* Copyright 2020 Confluent Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * =============================================================================
 *
 * Produce messages to Confluent Cloud
 * Using the node-rdkafka client for Apache Kafka
 *
 * =============================================================================
 */ 

const Kafka = require('node-rdkafka');
const { configFromCli } = require('./config');

const ERR_TOPIC_ALREADY_EXISTS = 36;

function ensureTopicExists(config, topic) {
  const adminClient = Kafka.AdminClient.create({
    'bootstrap.servers': config['bootstrap.servers'],
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
    'bootstrap.servers': config['bootstrap.servers'],
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
  const config = await configFromCli();

  if (config.usage) {
    return console.log(config.usage);
  }

  await ensureTopicExists(config, body.topic);

  const producer = await createProducer(config, (err, report) => {
    if (err) {
      console.warn('Error producing', err)
    } else {
      const {topic, partition, value} = report;
      console.log(`Successfully produced record to topic "${topic}" partition ${partition} ${value}`);
    }
  });

  
  for (let idx = 0; idx < Object.keys(body.messages[0]).length; ++idx) {
    const key = body.key;
    const value = Buffer.from(JSON.stringify({ count: idx }));
    const message = Buffer.from(JSON.stringify({ message: body.messages[idx].value }));
    console.log(`Producing record ${key}\t${value}`);
  
    producer.produce(body.topic, -1, message, key);
  }

  producer.flush(10000, () => {
    producer.disconnect();
  });
}

/*produceExample()
  .catch((err) => {
    console.error(`Something went wrong:\n${err}`);
    process.exit(1);
  });*/
