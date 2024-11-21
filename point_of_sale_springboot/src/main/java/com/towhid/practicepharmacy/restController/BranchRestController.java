package com.towhid.practicepharmacy.restController;

import com.towhid.practicepharmacy.entity.Branch;
import com.towhid.practicepharmacy.entity.Category;
import com.towhid.practicepharmacy.service.BranchService;
import com.towhid.practicepharmacy.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/branch")
@CrossOrigin(origins = "http://localhost:4200/")

public class BranchRestController {

    @Autowired
    private BranchService branchService;



    @GetMapping("/")
    public List<Branch> getAllBranch() {

        return branchService.getAllBranch();
    }

    @PostMapping("/save")
    public ResponseEntity<Branch> saveBranch(@RequestBody Branch b) {
        branchService.saveBranch(b);
        return new ResponseEntity<>(b, HttpStatus.CREATED);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteBranch(@PathVariable int id) {

        branchService.deleteBranchById(id);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity <Branch>updateBranch(@RequestBody Branch b,@PathVariable int id) {
        Branch branch= branchService.updateBranch(b,id);
        return new ResponseEntity<>(branch, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public  Branch getBranchById(@PathVariable("id") int id) {

        return  branchService.findByid(id);

    }



}
