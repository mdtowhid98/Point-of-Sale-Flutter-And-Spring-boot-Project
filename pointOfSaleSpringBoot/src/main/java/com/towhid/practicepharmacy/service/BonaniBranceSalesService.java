//package com.towhid.practicepharmacy.service;
//
//import com.towhid.practicepharmacy.entity.BonaniBranceSales;
//import com.towhid.practicepharmacy.entity.Product;
//import com.towhid.practicepharmacy.entity.Sales;
//import com.towhid.practicepharmacy.entity.SalesDetails;
//import com.towhid.practicepharmacy.repository.BonaniBranceRepository;
//import com.towhid.practicepharmacy.repository.ProductRepository;
//import com.towhid.practicepharmacy.repository.SalesDetailsRepository;
//import com.towhid.practicepharmacy.repository.SalesRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Service
//public class BonaniBranceSalesService {
//
//    @Autowired
//    private ProductRepository productRepository;
//
//    @Autowired
//    private BonaniBranceRepository bonaniBranceRepository;
//
//    @Autowired
//    private SalesDetailsRepository salesDetailsRepository;
//
//    // Fetch products from "Dhanmondi" branch
//    public List<Product> getBonaniBranchProducts() {
//        return productRepository.findByBranch_BranchName("Bonani");
//    }
//
//    // Save sales and manage product stock
//    public BonaniBranceSales saveSalesBonani(BonaniBranceSales sales) {
//        BonaniBranceSales savedSales = bonaniBranceRepository.save(sales);
//
//        for (Product soldProduct : savedSales.getProduct()) {
//            Product product = productRepository.findById(soldProduct.getId())
//                    .orElseThrow(() -> new RuntimeException("Product not found with ID " + soldProduct.getId()));
//
//            if (!"Bonani".equalsIgnoreCase(product.getBranch().getBranchName())) {
//                throw new RuntimeException("Product " + product.getName() + " is not available in the Bonani branch.");
//            }
//
//            int newStock = product.getStock() - soldProduct.getQuantity();
//            if (newStock < 0) {
//                throw new RuntimeException("Not enough stock for product " + product.getName());
//            }
//
//            product.setStock(newStock);
//            productRepository.save(product);
//
//            // Save sales details
//            SalesDetails salesDetails = new SalesDetails();
//            salesDetails.setBonaniBranceSales(savedSales);
//            salesDetails.setProduct(product);
//            salesDetails.setQuantity(soldProduct.getQuantity());
//            salesDetails.setUnitPrice(product.getUnitprice());
//            salesDetails.setDiscount(sales.getDiscount());
//
//            float discount = sales.getDiscount();
//            float totalPrice = soldProduct.getQuantity() * product.getUnitprice() * (1 - discount / 100);
//            salesDetails.setTotalPrice(totalPrice);
//
//            salesDetailsRepository.save(salesDetails);
//        }
//
//        return savedSales;  // Now returning BonaniBranceSales
//    }
//
//    // Delete sales by ID
//    public void deleteSalesById(int id) {
//        bonaniBranceRepository.deleteById(id);
//    }
//}
