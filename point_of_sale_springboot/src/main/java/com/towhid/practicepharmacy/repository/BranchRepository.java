package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.Branch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BranchRepository extends JpaRepository<Branch,Integer> {

}
