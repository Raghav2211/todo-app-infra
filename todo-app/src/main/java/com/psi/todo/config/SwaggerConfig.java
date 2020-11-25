/**
 * 
 */
package com.psi.todo.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.info.BuildProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.psi.todo.TodoApplication;

import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class SwaggerConfig {

    private String appName;
    private String appDescription;
    private BuildProperties buildProperties;

    public SwaggerConfig(BuildProperties buildProperties, @Value("${info.app.name}") String appName,
            @Value("${info.app.description}") String appDescription) {
        this.buildProperties = buildProperties;
        this.appName = appName;
        this.appDescription = appDescription;
    }

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2).useDefaultResponseMessages(false).select()
                .apis(RequestHandlerSelectors.basePackage(TodoApplication.class.getPackageName())).paths(PathSelectors.any()).build()
                .apiInfo(metaData());
    }

    private ApiInfo metaData() {
        return new ApiInfo(appName, appDescription, buildProperties.getVersion(), "Terms of service",
                new Contact("Todo", "https://github.com/Raghav2211/kubernetes-lab.git", "todo@todo.com"),
                "Todo Licence", "http://localhost:8080", List.of());
    }

}
