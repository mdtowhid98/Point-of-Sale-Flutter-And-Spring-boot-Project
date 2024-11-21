package com.towhid.practicepharmacy.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Customers")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private int cell;

    private String address;

//    @JsonIgnore
//    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
//    private List<SalesOrder> salesOrders;

    public Customer(int id) {
        this.id = id;
    }

}
