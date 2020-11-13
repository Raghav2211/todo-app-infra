package com.klab.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.klab.entity.Todo;
import com.klab.service.ITodoService;

@RestController
@RequestMapping(value = { "/todo" })
public class TodoController {

    private ITodoService todoService;

    public TodoController(ITodoService todoService) {
        this.todoService = todoService;
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Todo> todoById(@PathVariable("id") long id) {
        Optional<Todo> todo = todoService.findById(id);
        return todo.isPresent() ? new ResponseEntity<Todo>(todo.get(), HttpStatus.OK)
                : new ResponseEntity<Todo>(HttpStatus.NOT_FOUND);
    }

    @PostMapping(headers = "Accept=application/json")
    public ResponseEntity<Void> createTodo(@RequestBody Todo todo, UriComponentsBuilder ucBuilder) {
        todoService.create(todo);
        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(ucBuilder.path("/todo/{id}").buildAndExpand(todo.getId()).toUri());
        return new ResponseEntity<Void>(headers, HttpStatus.CREATED);
    }

    @GetMapping(headers = "Accept=application/json")
    public List<Todo> getAllTodo() {
        return StreamSupport.stream(todoService.findAll().spliterator(), false).collect(Collectors.toList());
    }

    @PutMapping(headers = "Accept=application/json")
    public ResponseEntity<String> updateTodo(@RequestBody Todo todo) {
        Optional<Todo> optTodo = todoService.findById(todo.getId());
        if (!optTodo.isPresent()) {
            return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
        }
        todoService.update(todo);
        return new ResponseEntity<String>(HttpStatus.OK);
    }

    @DeleteMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<Todo> deleteTodo(@PathVariable("id") long id) {
        Optional<Todo> optTodo = todoService.findById(id);
        if (!optTodo.isPresent()) {
            return new ResponseEntity<Todo>(HttpStatus.NOT_FOUND);
        }
        todoService.delete(id);
        return new ResponseEntity<Todo>(HttpStatus.NO_CONTENT);
    }

}