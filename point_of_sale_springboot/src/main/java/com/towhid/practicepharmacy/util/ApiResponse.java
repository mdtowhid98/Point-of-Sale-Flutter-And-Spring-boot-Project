package com.towhid.practicepharmacy.util;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor

public class ApiResponse {

    private boolean successful;
    private String message;
    private Map<String, Object> data = new HashMap<>(); // Holds the response data

    // Constructor
    public ApiResponse(boolean successful, String message) {
        this.successful = successful;
        this.message = message;

    }

    // Getters and Setters
    public boolean isSuccessful() {
        return successful;
    }

    public void setSuccessful(boolean successful) {
        this.successful = successful;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }

}
