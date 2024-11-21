package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.Product;
import com.towhid.practicepharmacy.entity.Sales;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SalesRepository extends JpaRepository<Sales,Integer> {



}
