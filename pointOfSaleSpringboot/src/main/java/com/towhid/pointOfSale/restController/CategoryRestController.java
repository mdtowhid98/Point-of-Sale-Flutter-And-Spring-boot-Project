package com.towhid.pointOfSale.restController;

import com.towhid.pointOfSale.entity.Category;
import com.towhid.pointOfSale.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/category")
@CrossOrigin(origins = "http://localhost:4200/")
public class CategoryRestController {

    @Autowired
    private CategoryService categoryService;



    @GetMapping("/")
    public List<Category> getAllCategory() {

        return categoryService.getAllCategory();
    }

    @PostMapping("/save")
    public ResponseEntity<Category> saveCategory(@RequestBody Category mc) {
        categoryService.saveCategory(mc);
        return new ResponseEntity<>(mc, HttpStatus.CREATED);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteCategory(@PathVariable int id) {

        categoryService.deleteCategoryById(id);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity <Category>updateCategory(@RequestBody Category mc,@PathVariable int id) {
        Category category= categoryService.updateCategory(mc,id);
        return new ResponseEntity<>(category, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public  Category getCategoryById(@PathVariable("id") int id) {

        return  categoryService.findByid(id);

    }



}
