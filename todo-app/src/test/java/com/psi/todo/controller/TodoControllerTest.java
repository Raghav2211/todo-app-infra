package com.psi.todo.controller;

import java.util.List;
import java.util.Optional;

import org.hamcrest.Matchers;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.psi.todo.dto.TodoResource;
import com.psi.todo.entity.Todo;
import com.psi.todo.repository.TodoRepository;
import com.psi.todo.service.ITodoService;
import com.psi.todo.validator.TodoExistsValidator;

import lombok.SneakyThrows;

@SpringBootTest(classes = { TodoController.class, TodoExistsValidator.class, TodoRepository.class })
@AutoConfigureMockMvc(addFilters = false)
@EnableWebMvc
public class TodoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ITodoService todoService;

    @MockBean
    private TodoRepository todoRepository;

    @SneakyThrows
    @Test
    public void testGetTodoById() {
        String response = "{\"id\":1,\"content\":\"Update Error content\",\"isComplete\":false}";
        Mockito.when(todoService.findById(1l))
                .thenReturn(Optional.of(new ObjectMapper().readValue(response, Todo.class)));
        Mockito.when(todoRepository.findById(1l))
                .thenReturn(Optional.of(new ObjectMapper().readValue(response, Todo.class)));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get("/todo/1").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(response));
    }

    @SneakyThrows
    @Test
    public void testGetTodoByIdNotFound() {
        Mockito.when(todoRepository.findById(Mockito.anyLong())).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get("/todo/1").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

    @SneakyThrows
    @Test
    public void testGetTodoByNullId() {
        Mockito.when(todoRepository.findById(Mockito.anyLong())).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get("/todo/null").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

    @SneakyThrows
    @Test
    public void testGetAllTodo() {
        String response = "{\"id\":1,\"content\":\"Update Error content\",\"isComplete\":false}";
        Todo todo = new ObjectMapper().readValue(response, Todo.class);
        Mockito.when(todoService.findAll()).thenReturn(List.of(todo));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get("/todo").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$", Matchers.hasSize(1)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.[0].id", Matchers.is(1)));
    }

    @SneakyThrows
    @Test
    public void testCreateTodo() {
        String response = "{\"id\":1,\"content\":\"Update Error content\",\"isComplete\":false}";
        String request = "{\"content\":\"Update Error content\",\"isComplete\":false}";
        TodoResource todo = new ObjectMapper().readValue(request, TodoResource.class);
        Mockito.when(todoService.create(todo)).thenReturn(new ObjectMapper().readValue(response, Todo.class));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.post("/todo").content(request).contentType(MEDIA_TYPE_JSON_UTF8)
                .accept(MEDIA_TYPE_JSON_UTF8)).andExpect(MockMvcResultMatchers.status().isCreated())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id", Matchers.is(1)));
    }

    @SneakyThrows
    @Test
    public void testCreateWithInvalidTodo() {
        String request = "{\"isComplete\":false}";
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.post("/todo").content(request).contentType(MEDIA_TYPE_JSON_UTF8)
                .accept(MEDIA_TYPE_JSON_UTF8)).andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

    @SneakyThrows
    @Test
    public void testUpdateTodo() {
        String response = "{\"id\":1,\"content\":\"Update Valid content\",\"isComplete\":false}";
        String request = "{\"content\":\"Update Valid content\",\"isComplete\":false}";
        TodoResource todo = new ObjectMapper().readValue(request, TodoResource.class);
        Mockito.when(todoService.update(todo, 1l)).thenReturn(new ObjectMapper().readValue(response, Todo.class));
        Mockito.when(todoRepository.findById(1l))
                .thenReturn(Optional.of(new ObjectMapper().readValue(response, Todo.class)));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.put("/todo/1").content(request).contentType(MEDIA_TYPE_JSON_UTF8)
                .accept(MEDIA_TYPE_JSON_UTF8)).andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id", Matchers.is(1)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.content", Matchers.is("Update Valid content")));
    }

    @SneakyThrows
    @Test
    public void testUpdateNonExistTodo() {
        String request = "{\"content\":\"Update Valid content\",\"isComplete\":false}";
        Mockito.when(todoRepository.findById(1l)).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.put("/todo/1").content(request).contentType(MEDIA_TYPE_JSON_UTF8)
                .accept(MEDIA_TYPE_JSON_UTF8)).andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

    @SneakyThrows
    @Test
    public void testUpdateNegativeIdTodo() {
        String request = "{\"content\":\"Update Valid content\",\"isComplete\":false}";
        Mockito.when(todoRepository.findById(-1l)).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.put("/todo/1").content(request).contentType(MEDIA_TYPE_JSON_UTF8)
                .accept(MEDIA_TYPE_JSON_UTF8)).andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

    @SneakyThrows
    @Test
    public void testDeleteTodo() {
        Mockito.doNothing().when(todoService).delete(1l);
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.delete("/todo/1").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isNoContent());
    }
    
    @SneakyThrows
    @Test
    public void testDeleteWithNegativeTodoId() {
        Mockito.doNothing().when(todoService).delete(1l);
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.delete("/todo/-1").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest());
    }

}
