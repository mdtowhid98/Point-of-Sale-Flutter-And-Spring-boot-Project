package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SupplierRepository extends JpaRepository<Supplier,Integer> {

}
