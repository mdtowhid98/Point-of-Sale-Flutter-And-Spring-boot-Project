package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category,Integer> {

}
