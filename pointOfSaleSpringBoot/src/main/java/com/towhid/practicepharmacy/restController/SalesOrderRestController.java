//package com.towhid.practicepharmacy.restController;
//
//
//import com.towhid.practicepharmacy.entity.Sales;
//import com.towhid.practicepharmacy.entity.SalesOrder;
//import com.towhid.practicepharmacy.service.SalesOrderService;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/salesorder")
//@CrossOrigin(origins = "http://localhost:4200/")
//public class SalesOrderRestController {
//
//    @Autowired
//    private SalesOrderService salesOrderService;
//
//    @GetMapping("/")
//    public List<SalesOrder> getAllSalesOrder() {
//
//        return salesOrderService.getAllSalesOrder();
//    }
//
//    @PostMapping("/save")
//    public ResponseEntity<String> createSalesOrder(@RequestBody SalesOrder salesOrder) {
//        try {
//            salesOrderService.saveSalesOrder(salesOrder);
//            return new ResponseEntity<>("Sales order created successfully.", HttpStatus.CREATED);
//        } catch (RuntimeException e) {
//            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
//        }
//    }
//
//}
//
