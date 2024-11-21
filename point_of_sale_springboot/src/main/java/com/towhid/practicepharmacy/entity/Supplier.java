package com.towhid.practicepharmacy.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Suppliers")
public class Supplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String email;
    private int cell;
    private String address;

    @JsonIgnore
    @OneToMany(mappedBy = "supplier", cascade = CascadeType.ALL)
    private List<Product> products;

    public Supplier(int id) {

        this.id = id;
    }

//    @JsonIgnore
//    @OneToMany(mappedBy = "supplier", cascade = CascadeType.ALL)
//    private List<SalesOrder> salesOrders;
}