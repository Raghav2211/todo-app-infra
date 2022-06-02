package com.psi.todo.dto;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;

import lombok.Data;

@Data
public class TodoDeleteRequest {
    @NotNull(message = "Tood id must not be null")
    @Positive(message = "Tood id must be grater than 0")
    private Long id;

}
