package com.klab.repository;

import org.springframework.data.repository.CrudRepository;

import com.klab.entity.Todo;

public interface TodoRepository extends CrudRepository<Todo,Long> {
}
