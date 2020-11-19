package com.klab.todo.service;

import java.util.Optional;

import com.klab.todo.entity.Todo;

public interface ITodoService {

    public Todo create(Todo user);

    public Todo update(Todo user);

    public Optional<Todo> findById(long id);

    public Iterable<Todo> findAll();

    public void delete(long id);

}
