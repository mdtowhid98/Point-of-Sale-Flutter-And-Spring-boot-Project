package com.towhid.pointOfSale.service;

import com.towhid.pointOfSale.entity.Customer;
import com.towhid.pointOfSale.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public void saveCustomer(Customer s) {

        customerRepository.save(s);
    }

    public List<Customer> getAllCustomer() {

        return customerRepository.findAll();
    }

    public void deleteCustomerById(int id) {

        customerRepository.deleteById(id);
    }

    public Customer findByid(int id) {

        return customerRepository.findById(id).get();
    }



    public Customer updateCustomer(Customer c, int id) {

        return customerRepository.save(c);
    }



}
