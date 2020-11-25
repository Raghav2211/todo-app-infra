package com.klab.todo.service;

import java.util.Optional;

import com.klab.todo.dto.TodoResource;
import com.klab.todo.entity.Todo;

public interface ITodoService {

    public Todo create(TodoResource todo);

    public Todo update(TodoResource todo,Long id);

    public Optional<Todo> findById(Long id);

    public Iterable<Todo> findAll();

    public void delete(Long id);

}
