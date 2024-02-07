package com.JSH.Meow;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;

import com.JSH.Meow.config.EnvConfig;

@SpringBootApplication
@PropertySource(value = {
        "classpath:env/env.yml"
/* , "classpath:env/env-key.yml" */
}, factory = EnvConfig.class)
public class MeowApplication {

	public static void main(String[] args) {
		SpringApplication.run(MeowApplication.class, args);
	}

}
