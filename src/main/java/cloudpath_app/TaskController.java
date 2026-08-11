package cloudpath_app;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TaskController {

    @Value("${app.message}")
    private String appMessage;

    private final List<String> tasks = List.of(
        "Learn Docker",
        "Setup CI/CD",
        "Deploy to Kubernetes"
    );

    @GetMapping("/tasks")
    public List<String> getTasks() {
        return tasks;
    }

    @GetMapping("/info")
    public String getInfo() {
        return appMessage;
    }
}
