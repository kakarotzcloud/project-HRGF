package com.example.demo;

import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final List<User> users = new ArrayList<>();

    @PostMapping
    public String addUser(@RequestBody User user) {
        users.add(user);
        return "User added successfully";
    }

    @GetMapping
    public List<User> getUsers() {
        return users;
    }
}