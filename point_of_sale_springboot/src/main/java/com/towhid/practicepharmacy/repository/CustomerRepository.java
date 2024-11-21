package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends JpaRepository<Customer,Integer> {

}
