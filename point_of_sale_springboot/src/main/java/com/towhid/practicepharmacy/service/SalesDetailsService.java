package com.towhid.practicepharmacy.service;


import com.towhid.practicepharmacy.entity.Sales;
import com.towhid.practicepharmacy.entity.SalesDetails;
import com.towhid.practicepharmacy.repository.SalesDetailsRepository;
import com.towhid.practicepharmacy.repository.SalesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class SalesDetailsService {


    @Autowired
    private  SalesDetailsRepository salesDetailRepository;


    public List<SalesDetails> getAllSalesDetails() {

        return salesDetailRepository.findAll();
    }

    public Map<Integer, List<SalesDetails>> getSalesDetailsGroupedBySalesId() {
        List<SalesDetails> allSalesDetails = salesDetailRepository.findAll();

        // Group by sales ID
        return allSalesDetails.stream()
                .collect(Collectors.groupingBy(sd -> sd.getSale().getId()));
    }



}
