package com.towhid.practicepharmacy.restController;

import com.towhid.practicepharmacy.entity.Product;
//import com.towhid.practicepharmacy.service.BonaniBranceSalesService;
import com.towhid.practicepharmacy.service.ProductService;
import com.towhid.practicepharmacy.service.SalesService;
import com.towhid.practicepharmacy.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/product")
@CrossOrigin(origins = "http://localhost:4200/")
public class ProductRestController {

    @Autowired
    private ProductService productService;
    @Autowired
    private SalesService salesService;
//    @Autowired
//    private BonaniBranceSalesService bonaniBranceSalesService;





    @PostMapping("/save")
    public ApiResponse saveProduct(
            @RequestPart(value = "product") Product product,
            @RequestParam(value = "image", required = true) MultipartFile file
    ) throws IOException {
        ApiResponse apiResponse = productService.saveProduct(product, file);
        return apiResponse;

    }




    @GetMapping("/")
    public ResponseEntity<List<Product>> getAllProduct() {
        List<Product> products = productService.getAllProduct();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/h/searchproduct")
    public ResponseEntity<List<Product>>findProductByCategoryName(@RequestParam(value ="categoryName" )String categoryName){
        List<Product> products=productService.findProductByCategoryName(categoryName);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/h/searchproductname")
    public ResponseEntity<List<Product>>findProductByName(@RequestParam(value ="productName" )String productName){
        List<Product> products=productService.findProductByName(productName);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/h/searchbrancenameandproductname")
    public ResponseEntity<List<Product>> findProductByNameAndBranch(
            @RequestParam("productName") String productName,
            @RequestParam("branchName") String branchName) {

        List<Product> products = productService.findProductByNameAndBranch(productName, branchName);

        if (products.isEmpty()) {
            return ResponseEntity.notFound().build();
        } else {
            return ResponseEntity.ok(products);
        }
    }

    @GetMapping("/h/searchbranchname")
    public ResponseEntity<List<Product>>findProductByBranchName(@RequestParam(value ="branchName" )String branchName){
        List<Product> products=productService.findProductByBranchName(branchName);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product>findProductById(@PathVariable int id){
        try {
            Product product=productService.findProductById(id);
            return ResponseEntity.ok(product);
        }
        catch (RuntimeException e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @DeleteMapping("/delete/{id}")
    public void deleteProduct(@PathVariable int id) {

        productService.deleteProductById(id);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Product> updateProduct(
            @PathVariable int id,
            @RequestPart("product") Product product,
            @RequestParam(value = "image", required = false) MultipartFile file) throws IOException {
        try {
            // Call the service method to update product
            Product updatedProduct = this.productService.updateProduct(product, id, file);
            return new ResponseEntity<>(updatedProduct, HttpStatus.OK);
        } catch (IOException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @GetMapping("/dhanmondi")
    public ResponseEntity<List<Product>> getDhanmondiBranchProducts() {
        List<Product> products = salesService.getDhanmondiBranchProducts();
        return ResponseEntity.ok(products);
    }

    // Get all products from the "Banani" branch
    @GetMapping("/banani")
    public ResponseEntity<List<Product>> getBananiBranchProducts() {
        List<Product> products = salesService.getBananiBranchProducts();
        return ResponseEntity.ok(products);
    }


    @GetMapping("/gulshan")
    public ResponseEntity<List<Product>> getGulshanBranchProducts() {
        List<Product> products = salesService.getGulshanBranchProducts();
        return ResponseEntity.ok(products);
    }


}