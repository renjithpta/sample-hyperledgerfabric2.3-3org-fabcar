package com.ibs.fly2plan;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;

@SpringBootApplication
@EnableKafka
public class Fly2ChainStarterConsumerApplication {

    public static void main(String[] args) {
        SpringApplication.run(Fly2ChainStarterConsumerApplication.class, args);
    }
}