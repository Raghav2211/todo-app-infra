package com.psi.todo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;


@SpringBootTest(properties = {"spring.datasource.url=jdbc:mysql://127.0.0.1:3306/klab", "spring.datasource.username=root","spring.datasource.password=root"})
class TodoApplicationTests {

	@Test
	void contextLoads() {
	}

}
