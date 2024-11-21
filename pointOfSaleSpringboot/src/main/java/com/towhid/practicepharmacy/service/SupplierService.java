package com.towhid.practicepharmacy.service;

import com.towhid.practicepharmacy.entity.Category;
import com.towhid.practicepharmacy.entity.Supplier;
import com.towhid.practicepharmacy.repository.CategoryRepository;
import com.towhid.practicepharmacy.repository.SupplierRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SupplierService {

    @Autowired
    private SupplierRepository supplierRepository;

    public void saveSupplier(Supplier s) {

        supplierRepository.save(s);
    }

    public List<Supplier> getAllSupplier() {

        return supplierRepository.findAll();
    }

    public void deleteSupplierById(int id) {

        supplierRepository.deleteById(id);
    }

    public Supplier findByid(int id) {

        return supplierRepository.findById(id).get();
    }



    public Supplier updateSupplier(Supplier s, int id) {

        return supplierRepository.save(s);
    }




}
