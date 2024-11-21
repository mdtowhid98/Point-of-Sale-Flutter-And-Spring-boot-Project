package com.towhid.practicepharmacy.service;

import com.towhid.practicepharmacy.entity.Branch;
import com.towhid.practicepharmacy.entity.Category;
import com.towhid.practicepharmacy.repository.BranchRepository;
import com.towhid.practicepharmacy.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BranchService {

    @Autowired
    private BranchRepository branchRepository;



    public void saveBranch(Branch b) {

        branchRepository.save(b);
    }

    public List<Branch> getAllBranch() {

        return branchRepository.findAll();
    }

    public void deleteBranchById(int id) {

        branchRepository.deleteById(id);
    }

    public Branch findByid(int id) {
        return branchRepository.findById(id).get();
    }



    public Branch updateBranch(Branch b, int id) {

        return branchRepository.save(b);
    }


}
