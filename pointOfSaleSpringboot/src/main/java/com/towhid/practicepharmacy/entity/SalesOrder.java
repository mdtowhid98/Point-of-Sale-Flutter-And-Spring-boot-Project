//package com.towhid.practicepharmacy.entity;
//
//import jakarta.persistence.*;
//import lombok.AllArgsConstructor;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//
//import java.sql.Date;
//import java.util.List;
//
//@Entity
//@Data
//@AllArgsConstructor
//@NoArgsConstructor
//@Table(name = "SalesOrders")
//public class SalesOrder {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private int id;
//
//    private Date orderDate;
//
////    private double totalAmount;
//
//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "customerId")
//    private Customer customer;
//
//
////    @ManyToOne(fetch = FetchType.EAGER)
////    @JoinColumn(name = "supplierId")
////    private Supplier supplier;
//
//    @ManyToMany(cascade = CascadeType.ALL)
//    @JoinTable(
//            name = "sales_order_products",
//            joinColumns = @JoinColumn(name = "salesOrder_id"),
//            inverseJoinColumns = @JoinColumn(name = "product_id")
//    )
//    private List<Product> products;
//
//}
//
