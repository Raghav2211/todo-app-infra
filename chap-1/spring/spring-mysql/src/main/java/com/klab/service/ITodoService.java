package com.klab.service;

import java.util.Optional;

import com.klab.entity.Todo;

public interface ITodoService {

    public void create(Todo user);

    public Todo update(Todo user);

    public Optional<Todo> findById(long id);

    public Iterable<Todo> findAll();

    public void delete(long id);

}
