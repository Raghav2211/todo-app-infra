package com.klab.todo.repository;

import org.springframework.data.repository.CrudRepository;

import com.klab.todo.entity.Todo;

public interface TodoRepository extends CrudRepository<Todo, Long> {
}
