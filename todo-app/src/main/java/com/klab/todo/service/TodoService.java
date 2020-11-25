package com.klab.todo.service;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klab.todo.dto.TodoResource;
import com.klab.todo.entity.Todo;
import com.klab.todo.repository.TodoRepository;

@Service
@Transactional
public class TodoService implements ITodoService {

    private TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public Todo create(TodoResource todoResource) {
        return todoRepository.save(mapTodo(todoResource));
    }

    public Todo update(TodoResource todoResource,Long id) {
        Optional<Todo> todo=todoRepository.findById(id);
        todo.get().setContent(todoResource.getContent());
        todo.get().setIsComplete(todoResource.getIsComplete());
        return todoRepository.save(todo.get());
    }

    public Optional<Todo> findById(Long id) {
        return todoRepository.findById(id);
    }

    public Iterable<Todo> findAll() {
        return todoRepository.findAll();
    }

    public void delete(Long id) {
         todoRepository.deleteById(id);
    }
    
    private Todo mapTodo(TodoResource todoResource) {
        Todo todo=new Todo();
        todo.setContent(todoResource.getContent());
        todo.setIsComplete(todoResource.getIsComplete());
        return todo;
    }
}
