package com.towhid.practicepharmacy.entity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SalesDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "sales_id", nullable = false)
    private Sales sale; // Reference back to Sales

//    @ManyToOne
//    @JoinColumn(name = "sales_bonani_id", nullable = false)
//    private BonaniBranceSales bonaniBranceSales; // Reference back to Sales

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    private int quantity;

    private float unitPrice;
    private float totalPrice;
    private float discount;

}
