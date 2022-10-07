package com.example.coverlo;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "payments.flutter/jazzcash";
    private static final int PAYMENT_ACTIVITY_RESULT_CODE = 101;
    private MethodChannel.Result _result;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            _result = result;
                            // This method is invoked on the main thread.
                            if (call.method.equals("performPayment")) {

                                String postData = call.argument("postData");
                                Intent intent = new Intent(MainActivity.this, PaymentActivity.class);
                                intent.putExtra("postData", postData);
                                startActivityForResult(
                                        intent,
                                        PAYMENT_ACTIVITY_RESULT_CODE);

                            } else {
                                result.notImplemented();
                            }
                        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PAYMENT_ACTIVITY_RESULT_CODE) {
            // Parse response data back as map
            String response = "";
            if (data != null) {
                response = data.getStringExtra("response");
            }

            _result.success(response);
        }
    }

}