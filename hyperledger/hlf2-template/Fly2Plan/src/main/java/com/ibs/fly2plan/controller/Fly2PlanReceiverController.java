package com.ibs.fly2plan.controller;



import com.ibs.fly2plan.producer.KafkaMessageProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.UUID;

@RestControllerAdvice
@RequestMapping("/api/aodbapp")
public class Fly2PlanReceiverController {

    private static final Logger LOGGER = LoggerFactory.getLogger(Fly2PlanReceiverController.class);

    private KafkaMessageProducer kafkaMessageProducer ;

    public Fly2PlanReceiverController() {

    }

    @RequestMapping(value = "/publish", method =  { RequestMethod.POST, RequestMethod.GET})
    public void publishMessagesOnKafka() {
        UUID key = UUID.randomUUID();
        LOGGER.info("sending messages to topic: {} with the key: {}", key);
        this.kafkaMessageProducer.getBankDetailsReactive()
                .doOnNext((bankDetail) -> bankDetailKafkaTemplate.send(TOPIC_NAME,key.toString(), bankDetail) )
                .doOnComplete(() ->   completionSignalKafkaTemplate.send(TOPIC_NAME, key.toString(),
                        new CompletionSignal(BankDetail.class, key.toString())))
                .subscribe();
    }


}
