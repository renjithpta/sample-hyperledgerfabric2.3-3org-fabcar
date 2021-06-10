package io.reflectoring.kafka;

import com.swayam.demo.springbootdemo.kafkadto.BankDetail;
import com.swayam.demo.springbootdemo.kafkadto.CompletionSignal;
import io.reflectoring.kafka.service.BankDetailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.UUID;

@RestControllerAdvice
@RequestMapping("/kafka")
public class BankDetailController {

    private static final Logger LOGGER = LoggerFactory.getLogger(BankDetailController.class);

    private static final String TOPIC_NAME = "bank-details";

    @Autowired
    private BankDetailService bankDetailService;




    @Autowired
    private KafkaTemplate<String, BankDetail> bankDetailKafkaTemplate;

    @Autowired
    private KafkaTemplate<String, CompletionSignal> completionSignalKafkaTemplate;





    public BankDetailController() {

    }

    @RequestMapping(value = "/publish", method = RequestMethod.GET)
    public void publishMessagesOnKafka() {
        UUID key = UUID.randomUUID();
        LOGGER.info("sending messages to topic: {} with the key: {}", TOPIC_NAME, key);
        this.bankDetailService.getBankDetailsReactive()
                .doOnNext((bankDetail) -> bankDetailKafkaTemplate.send(TOPIC_NAME,key.toString(), bankDetail) )
                .doOnComplete(() ->   completionSignalKafkaTemplate.send(TOPIC_NAME, key.toString(),
                        new CompletionSignal(BankDetail.class, key.toString())))
                .subscribe();
    }

}