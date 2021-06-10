package com.ibs.fly2plan.controller;



import com.ibs.fly2plan.models.AirportAcris;
import com.ibs.fly2plan.producer.KafkaMessageProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestControllerAdvice
@RequestMapping("/api/aodbapp")
public class Fly2PlanReceiverController {

    private final Logger LOG = LoggerFactory.getLogger(getClass());

    @Autowired
    private KafkaMessageProducer kafkaMessageProducer ;

    @Value("${fly2plan.kafka_topic.apllication}")
    private String aodbtopic;

    public Fly2PlanReceiverController() {

    }

    @RequestMapping(value = "/publish", method =  { RequestMethod.POST, RequestMethod.GET})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void publishMessagesOnKafka(@RequestBody AirportAcris airportAcris) {
        UUID key = UUID.randomUUID();
        LOG.info("sending messages to topic: {} with the key: {}", airportAcris);
        this.kafkaMessageProducer.sendMessage(airportAcris, key.toString(), aodbtopic);
    }


}
