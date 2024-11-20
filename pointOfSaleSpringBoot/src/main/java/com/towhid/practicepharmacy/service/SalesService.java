package com.towhid.practicepharmacy.service;

import com.towhid.practicepharmacy.entity.Product;
import com.towhid.practicepharmacy.entity.Sales;
import com.towhid.practicepharmacy.entity.SalesDetails;
import com.towhid.practicepharmacy.repository.CategoryRepository;
import com.towhid.practicepharmacy.repository.ProductRepository;
import com.towhid.practicepharmacy.repository.SalesDetailsRepository;
import com.towhid.practicepharmacy.repository.SalesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SalesService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private SalesRepository salesRepository;

    @Autowired
    private SalesDetailsRepository salesDetailsRepository;

    public List<Sales> getAllSales() {

        return salesRepository.findAll();
    }

    // Fetch products from "Dhanmondi" branch
    public List<Product> getDhanmondiBranchProducts() {
        return productRepository.findByBranch_BranchName("Dhanmondi");
    }

    // Fetch products from "Banani" branch
    public List<Product> getBananiBranchProducts() {
        return productRepository.findByBranch_BranchName("Banani");
    }

    public List<Product> getGulshanBranchProducts() {
        return productRepository.findByBranch_BranchName("Gulshan");
    }

    // Save sales and manage product stock for "Dhanmondi" branch
    public Sales saveSalesForDhanmondi(Sales sales) {
        return saveSalesForBranch(sales, "Dhanmondi");
    }

    // Save sales and manage product stock for "Banani" branch
    public Sales saveSalesForBanani(Sales sales) {
        return saveSalesForBranch(sales, "Banani");
    }

    public Sales saveSalesForGulshan(Sales sales) {
        return saveSalesForBranch(sales, "Gulshan");
    }

    // General method to handle sales for any branch
    private Sales saveSalesForBranch(Sales sales, String branchName) {
        Sales savedSales = salesRepository.save(sales);

        for (Product soldProduct : savedSales.getProduct()) {
            Product product = productRepository.findById(soldProduct.getId())
                    .orElseThrow(() -> new RuntimeException("Product not found with ID " + soldProduct.getId()));

            // Check if the product belongs to the correct branch
            if (!branchName.equalsIgnoreCase(product.getBranch().getBranchName())) {
                throw new RuntimeException("Product " + product.getName() + " is not available in the " + branchName + " branch.");
            }

            int newStock = product.getStock() - soldProduct.getQuantity();
            if (newStock < 0) {
                throw new RuntimeException("Not enough stock for product " + product.getName());
            }

            product.setStock(newStock);
            productRepository.save(product);

            // Save sales details
            SalesDetails salesDetails = new SalesDetails();
            salesDetails.setSale(savedSales);
            salesDetails.setProduct(product);
            salesDetails.setQuantity(soldProduct.getQuantity());
            salesDetails.setUnitPrice(product.getUnitprice());
            salesDetails.setDiscount(sales.getDiscount());

            // Calculate total price after discount
            float discount = sales.getDiscount();
            float totalPrice = soldProduct.getQuantity() * product.getUnitprice() * (1 - discount / 100);
            salesDetails.setTotalPrice(totalPrice);

            salesDetailsRepository.save(salesDetails);
        }

        return savedSales;
    }

    // Delete sales by ID
    public void deleteSalesById(int id) {
        salesRepository.deleteById(id);
    }
}