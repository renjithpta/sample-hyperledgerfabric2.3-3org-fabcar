package io.reflectoring.kafka.service;

import java.util.List;

import com.swayam.demo.springbootdemo.kafkadto.BankDetail;

import com.swayam.demo.springbootdemo.kafkadto.BankDetail;
import reactor.core.publisher.Flux;

public interface BankDetailService {

    List<BankDetail> getBankDetails();

    Flux<BankDetail> getBankDetailsReactive();

}