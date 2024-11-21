package com.towhid.practicepharmacy.restController;

import com.towhid.practicepharmacy.entity.Sales;
import com.towhid.practicepharmacy.entity.SalesDetails;
import com.towhid.practicepharmacy.service.SalesDetailsService;
import com.towhid.practicepharmacy.service.SalesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/salesdetails")
@CrossOrigin(origins = "http://localhost:4200/")
public class SalesDetailsController {

    @Autowired
    private SalesDetailsService salesDetailsService;

    @GetMapping("/")
    public List<SalesDetails> getAllSales(){

        return salesDetailsService.getAllSalesDetails();
    }

    @GetMapping("/grouped")
    public ResponseEntity<Map<Integer, List<SalesDetails>>> getGroupedSalesDetails() {
        Map<Integer, List<SalesDetails>> groupedSalesDetails = salesDetailsService.getSalesDetailsGroupedBySalesId();
        return ResponseEntity.ok(groupedSalesDetails);
    }


}
