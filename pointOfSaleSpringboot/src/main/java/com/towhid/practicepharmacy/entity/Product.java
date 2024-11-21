package com.towhid.practicepharmacy.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "product")


public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private int id;

    private String name;

    private String photo;

    private int stock;

    private int quantity;

    private int unitprice;
//    private float discount;

    private Date manufactureDate;

    private Date expiryDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "categoryId")
    private Category category;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "supplierId")
    private Supplier supplier;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "branchId")
    private Branch branch;

    //    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "salesOrderId")
//    private SalesOrder salesOrder;
//    @JsonIgnore
//    @OneToMany(mappedBy = "products", cascade = CascadeType.ALL)
//    private List<SalesOrder> salesOrders;

    public Product(int id) {

        this.id = id;
    }

//    @ManyToOne
//    private SalesDetails salesDetails;

}
