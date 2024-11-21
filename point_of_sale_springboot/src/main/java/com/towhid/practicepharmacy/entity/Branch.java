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
@Table(name = "Branches")


public class Branch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String branchName;
    private String location;

//    @JsonIgnore
//    @OneToMany(mappedBy = "branch", cascade = CascadeType.ALL)
//    private List<Sales> sales;

    @JsonIgnore
    @OneToMany(mappedBy = "branch", cascade = CascadeType.ALL)
    private List<Product> products;

    public Branch(int id) {

        this.id = id;
    }


    // Additional relationship examples
    // @OneToMany(mappedBy = "branch", cascade = CascadeType.ALL)
    // private List<Supplier> suppliers;
}
