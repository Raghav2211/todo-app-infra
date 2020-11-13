package com.klab.todo.exception;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TodoException {

    private String message;
    private String requestedURI;

 
}
