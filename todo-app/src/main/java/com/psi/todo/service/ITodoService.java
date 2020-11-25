package com.psi.todo.service;

import java.util.Optional;

import com.psi.todo.dto.TodoResource;
import com.psi.todo.entity.Todo;

public interface ITodoService {

    public Todo create(TodoResource todo);

    public Todo update(TodoResource todo,Long id);

    public Optional<Todo> findById(Long id);

    public Iterable<Todo> findAll();

    public void delete(Long id);

}
