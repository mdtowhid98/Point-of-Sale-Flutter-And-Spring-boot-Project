package com.towhid.practicepharmacy.restController;

import com.towhid.practicepharmacy.entity.Category;
import com.towhid.practicepharmacy.entity.Supplier;
import com.towhid.practicepharmacy.service.CategoryService;
import com.towhid.practicepharmacy.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/supplier")
@CrossOrigin(origins = "http://localhost:4200/")
public class SupplierRestController {

    @Autowired
    private SupplierService supplierService;



    @GetMapping("/")
    public List<Supplier> getAllSupplier() {

        return supplierService.getAllSupplier();
    }

    @PostMapping("/save")
    public ResponseEntity<Supplier> saveSupplier(@RequestBody Supplier s) {
        supplierService.saveSupplier(s);
        return new ResponseEntity<>(s, HttpStatus.CREATED);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteSupplier(@PathVariable int id) {

        supplierService.deleteSupplierById(id);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity <Supplier>updateSupplier(@RequestBody Supplier s,@PathVariable int id) {
        Supplier supplier= supplierService.updateSupplier(s,id);
        return new ResponseEntity<>(supplier, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public  Supplier getSupplierById(@PathVariable("id") int id) {

        return  supplierService.findByid(id);

    }



}
