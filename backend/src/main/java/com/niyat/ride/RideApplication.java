package com.niyat.ride;

import com.twilio.rest.api.v2010.account.Message; // Correct import
import com.twilio.type.PhoneNumber;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.twilio.Twilio;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@SpringBootApplication
public class RideApplication {
    public static void main(String[] args) {
        SpringApplication.run(RideApplication.class, args);
//        String apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJpZGVudGlmaWVyIjoieEdYUVRya3VHODY0VEtUYktJWGNXdXIyOUFYS0pPclkiLCJleHAiOjE5MTI5MjEwMjksImlhdCI6MTc1NTE1NDYyOSwianRpIjoiOWEzOTE2MmEtYjE0NS00NmRjLThlYmEtZTMyYTU2MTAzNmFlIn0.4NDTmZRa5vo2BkT0fqEL_vsGMfjqzPYJ1RZNlzCCjVs"; // Your API key
//        String sender = "Niyat Otp"; // Verified sender name
//        String to = "+251989634272";   // Recipient phone number
//        String message = "Test SMS";
//
//
//        try {
//            URL url = new URL("https://api.afromessage.com/api/send"); // Confirm endpoint
//
//            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//            conn.setRequestMethod("POST");
//            conn.setDoOutput(true);
//
//            // Correct header for AfroMessage
//            conn.setRequestProperty("Content-Type", "application/json");
//            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
//
//            // JSON body
//            String jsonInputString = String.format(
//                    "{\"from\":\"%s\",\"to\":\"%s\",\"text\":\"%s\"}",
//                    sender, to, message
//            );
//
//            try (OutputStream os = conn.getOutputStream()) {
//                byte[] input = jsonInputString.getBytes("utf-8");
//                os.write(input, 0, input.length);
//            }
//
//            int statusCode = conn.getResponseCode();
//            System.out.println("Response Code: " + statusCode);
//            conn.getInputStream().transferTo(System.out);
//
//            conn.disconnect();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    }
}
