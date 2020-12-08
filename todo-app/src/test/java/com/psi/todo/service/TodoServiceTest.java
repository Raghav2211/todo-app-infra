package com.psi.todo.service;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.psi.todo.dto.TodoResource;
import com.psi.todo.entity.Todo;
import com.psi.todo.repository.TodoRepository;

import lombok.SneakyThrows;

@SpringBootTest(classes = {TodoService.class})
public class TodoServiceTest {
    
    @MockBean
    private TodoRepository todoRepository;
    
    
    @Autowired
    private TodoService todoService;
    
    @SneakyThrows
    @Test
    public void testCreate() {
        String response = "{\"id\":1,\"content\":\"Update Error content\",\"isComplete\":false}";
        String request = "{\"content\":\"Update Error content\",\"isComplete\":false}";
        TodoResource todoResource = new ObjectMapper().readValue(request, TodoResource.class);
        Mockito.when(todoRepository.save(Mockito.any())).thenReturn(new ObjectMapper().readValue(response, Todo.class));
        Mockito.when(todoRepository.findById(1l))
                .thenReturn(Optional.of(new ObjectMapper().readValue(response, Todo.class)));
        Todo todoResponse=todoService.create(todoResource);
        assertEquals(1L, todoResponse.getId());
    }
    
    @SneakyThrows
    @Test
    public void testUpdate() {
        String response = "{\"id\":1,\"content\":\"Update Sucessfull content\",\"isComplete\":false}";
        String request = "{\"content\":\"Update Sucessfull contentt\",\"isComplete\":false}";
        TodoResource todoResource = new ObjectMapper().readValue(request, TodoResource.class);
        Mockito.when(todoRepository.save(Mockito.any())).thenReturn(new ObjectMapper().readValue(response, Todo.class));
        Mockito.when(todoRepository.findById(1l))
                .thenReturn(Optional.of(new ObjectMapper().readValue(response, Todo.class)));
        Todo todoResponse=todoService.update(todoResource,1l);
        assertEquals("Update Sucessfull content", todoResponse.getContent());
    }
    
    @SneakyThrows
    @Test
    public void testDelete() {
        String record = "{\"id\":1,\"content\":\"Update Sucessfull content\",\"isComplete\":false}";
        Todo todo=new ObjectMapper().readValue(record, Todo.class);
        Mockito.when(todoRepository.findById(1l)).thenReturn(Optional.of(todo));
        Mockito.doNothing().when(todoRepository).deleteById(1l);
        todoService.delete(1l);
    }
    
    @SneakyThrows
    @Test
    public void testFindById() {
        String record = "{\"id\":1,\"content\":\"Update Sucessfull content\",\"isComplete\":false}";
        Todo todo=new ObjectMapper().readValue(record, Todo.class);
        Mockito.when(todoRepository.findById(1l)).thenReturn(Optional.of(todo));
        assertEquals(1l, todoService.findById(1l).get().getId());
    }
    
    @SneakyThrows
    @Test
    public void testFindAll() {
        String response = "{\"id\":1,\"content\":\"Update Error content\",\"isComplete\":false}";
        Todo todo = new ObjectMapper().readValue(response, Todo.class);
        Mockito.when(todoRepository.findAll()).thenReturn(List.of(todo));
        assertEquals(1l, todoService.findAll().iterator().next().getId());
    }

}
