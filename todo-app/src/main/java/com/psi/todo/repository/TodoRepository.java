package com.psi.todo.repository;

import org.springframework.data.repository.CrudRepository;

import com.psi.todo.entity.Todo;

public interface TodoRepository extends CrudRepository<Todo, Long> {
}
