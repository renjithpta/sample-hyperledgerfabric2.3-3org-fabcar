package com.ibs.fly2plan.configs;

import com.ibs.fly2plan.models.MessageWrapper;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.errors.TimeoutException;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

@Configuration
class KafkaConsumerConfig {


    @Value("${kafka.brokers}")
    private String bootstrapServers;
    @Value("${kafka.reconnect-backoff-ms}")
    private String backOffMs;
    @Value("${kafka.max-block-ms}")
    private String  maxBlockMs;


    public ConsumerFactory<String, MessageWrapper> messageWrapperConsumerFactory() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "aodb_group");
        props.put(ProducerConfig.RECONNECT_BACKOFF_MS_CONFIG, backOffMs);
        props.put(ProducerConfig.MAX_BLOCK_MS_CONFIG, maxBlockMs);

        return new DefaultKafkaConsumerFactory<>(props, new StringDeserializer(), new JsonDeserializer<>(MessageWrapper.class));
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, MessageWrapper> aodbKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, MessageWrapper> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(messageWrapperConsumerFactory());
        return factory;
    }




}