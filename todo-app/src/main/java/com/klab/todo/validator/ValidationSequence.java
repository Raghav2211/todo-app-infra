package com.klab.todo.validator;

import javax.validation.GroupSequence;
import javax.validation.groups.Default;

@GroupSequence({ Default.class, Minimal.class, Advance.class })
public interface ValidationSequence {
}