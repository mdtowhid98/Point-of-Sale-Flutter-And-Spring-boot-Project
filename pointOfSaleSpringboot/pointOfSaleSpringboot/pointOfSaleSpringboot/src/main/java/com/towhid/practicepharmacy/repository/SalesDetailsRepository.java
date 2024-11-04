package com.towhid.pointOfSale.repository;

import com.towhid.pointOfSale.entity.Product;
import com.towhid.pointOfSale.entity.Sales;
import com.towhid.pointOfSale.entity.SalesDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface SalesDetailsRepository  extends JpaRepository<SalesDetails, Integer> {

    // Custom query to find SalesDetails based on customer name through Sales entity

    // Find all SalesDetails for a specific Sales ID
    List<SalesDetails> findBySaleId(int salesId);

    // Custom query to group SalesDetails by Sales ID
    @Query("SELECT sd FROM SalesDetails sd GROUP BY sd.sale.id")
    List<SalesDetails> findSalesDetailsGroupedBySalesId();



}
