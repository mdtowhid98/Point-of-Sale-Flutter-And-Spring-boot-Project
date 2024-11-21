//package com.towhid.practicepharmacy.restController;
//
//import com.towhid.practicepharmacy.entity.BonaniBranceSales;
//import com.towhid.practicepharmacy.entity.Product;
//import com.towhid.practicepharmacy.entity.Sales;
//import com.towhid.practicepharmacy.service.BonaniBranceSalesService;
//import com.towhid.practicepharmacy.service.SalesService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/bonanibranch")
//@CrossOrigin(origins = "http://localhost:4200/")
//
//public class BonaniBranceSalesRestController {
//
//    @Autowired
//    private BonaniBranceSalesService bonaniBranceSalesService;
//
//
//
//    @GetMapping("/")
//    public List<Product> getAllSalesBonaniBranch(){
//        return bonaniBranceSalesService.getBonaniBranchProducts();
//    }
//
//    @PostMapping("/save")
//    public ResponseEntity<BonaniBranceSales> createSaleBonani(@RequestBody BonaniBranceSales sales) {
//        BonaniBranceSales savedSales = bonaniBranceSalesService.saveSalesBonani(sales);
//        return ResponseEntity.ok(savedSales);
//    }
//
//
//    @DeleteMapping("/delete/{id}")
//    public void deleteProduct(@PathVariable int id) {
//
//        bonaniBranceSalesService.deleteSalesById(id);
//    }
//
//
//}
//
