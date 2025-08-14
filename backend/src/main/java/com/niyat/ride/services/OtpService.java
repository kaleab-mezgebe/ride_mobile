package com.niyat.ride.services;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    private static final String ACCOUNT_SID = "ACe7ffdab938eba8d8e383417c3d113318";
    private static final String AUTH_TOKEN = "36465e1fe5c89718d7147e2a48378c83";
    private static final String TWILIO_PHONE = "+14063028320";

    // Temporary OTP storage
    private final Map<String, String> otpStorage = new ConcurrentHashMap<>();

    public OtpService() {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
    }

    public String generateOtp() {
        return String.valueOf(new Random().nextInt(900000) + 100000); // 6-digit OTP
    }

    public void sendOtp(String phoneNumber) {
        String otp = generateOtp();
        otpStorage.put(phoneNumber, otp);

        Message.creator(
                new PhoneNumber("+251" + phoneNumber), // Ethiopian numbers
                new PhoneNumber(TWILIO_PHONE),
                "Your Niyat Ride OTP code is: " + otp
        ).create();
    }

    public boolean verifyOtp(String phoneNumber, String otp) {
        return otp.equals(otpStorage.get(phoneNumber));
    }

    public void clearOtp(String phoneNumber) {
        otpStorage.remove(phoneNumber);
    }
}
