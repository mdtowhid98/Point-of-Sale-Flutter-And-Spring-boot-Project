//package com.towhid.practicepharmacy.service;
//
//
//import com.towhid.practicepharmacy.entity.*;
//import com.towhid.practicepharmacy.repository.*;
//import com.towhid.practicepharmacy.util.ApiResponse;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Optional;
//
//@Service
//public class SalesOrderService {
//
//    @Autowired
//    private SalesOrderRepository salesOrderRepository;
//
//    @Autowired
//    private ProductRepository productRepository;
//
//    @Autowired
//    private CustomerRepository customerRepository;
//
////    @Autowired
////    private SupplierRepository supplierRepository;
//
//
//    public List<SalesOrder> getAllSalesOrder() {
//
//        return salesOrderRepository.findAll();
//    }
//
//    public void saveSalesOrder(SalesOrder salesOrder) {
//        // Check if customer exists
//        Customer customer = customerRepository.findById(salesOrder.getCustomer().getId())
//                .orElseThrow(() -> new RuntimeException("Customer not found with ID: " + salesOrder.getCustomer().getId()));
//        salesOrder.setCustomer(customer);
//
//        // Check if supplier exists
////        Supplier supplier = supplierRepository.findById(salesOrder.getSupplier().getId())
////                .orElseThrow(() -> new RuntimeException("Supplier not found with ID: " + salesOrder.getSupplier().getId()));
////        salesOrder.setSupplier(supplier);
//
//        // Iterate over products and verify them
//        List<Product> attachedProducts = new ArrayList<>();
//        for (Product soldProduct : salesOrder.getProducts()) {
//            // Fetch each product from the repository (attach the product to the persistence context)
//            Product product = productRepository.findById(soldProduct.getId())
//                    .orElseThrow(() -> new RuntimeException("Product not found with ID: " + soldProduct.getId()));
//
//            // Handle stock validation or any other processing logic
//            // For example, checking if the quantity ordered exceeds available stock
//            if (soldProduct.getStock() > product.getStock()) {
//                throw new RuntimeException("Insufficient stock for product: " + product.getName());
//            }
//
//            // Update the stock by subtracting the sold quantity
//            product.setStock(product.getStock() - soldProduct.getStock());
//
//            // Add the attached product to the list
//            attachedProducts.add(product);
//        }
//
//        // Set the attached products list to the sales order
//        salesOrder.setProducts(attachedProducts);
//
//        // Save the sales order (now the products are attached to the persistence context)
//        salesOrderRepository.save(salesOrder);
//    }
//    public Optional<SalesOrder> getSalesOrderById(int id) {
//        return salesOrderRepository.findById(id);
//    }
//
//
//}
//
//
//
//
