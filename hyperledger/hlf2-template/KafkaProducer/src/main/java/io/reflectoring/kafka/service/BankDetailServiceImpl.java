package io.reflectoring.kafka.service;

import java.util.List;

import com.swayam.demo.springbootdemo.kafkadto.BankDetail;
import io.reflectoring.kafka.dao.BankDetailDao;
import org.springframework.stereotype.Service;



import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxSink;

@Service
public class BankDetailServiceImpl implements BankDetailService {

    private final BankDetailDao bankDetailDao;

    public BankDetailServiceImpl(BankDetailDao bankDetailDao) {
        this.bankDetailDao = bankDetailDao;
    }

    @Override
    public List<BankDetail> getBankDetails() {
        return bankDetailDao.getBankDetails();
    }

    @Override
    public Flux<BankDetail> getBankDetailsReactive() {
        return Flux.create((FluxSink<BankDetail> fluxSink) -> {
            bankDetailDao.publishBankDetails(fluxSink);
        });
    }

}