package com.example.ble_advertisement;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.le.AdvertiseCallback;
import android.bluetooth.le.AdvertiseData;
import android.bluetooth.le.AdvertiseSettings;
import android.bluetooth.le.BluetoothLeAdvertiser;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

//import androidx.annotation.RequiresApi;

import androidx.annotation.RequiresApi;
import androidx.core.app.AppComponentFactory;

import java.nio.charset.Charset;

class BluetoothHelper {
    /*
     * Assigned Company IDs are from Bluetooth SIG to SIG members.
     * As of now, we should feel free to choose any ID which does not conflict (Last ID on 21st Jan is 0x0857)
     * */
    private static  final int CHANGEPAY_COMPANY_ID=50596;//0xC5A4 (CPAY0)
    private static BluetoothHelper mInstance;
    private  AdvertiseCallback mAdvertiseCallback;
    private BluetoothAdapter mBluetoothAdapter;
    private BluetoothLeAdvertiser mAdvertiser;
    private static Boolean isAdvertising = false;

    private BluetoothHelper(){
    }

    public static BluetoothHelper getInstance(){
        /*
         * Why Singleton?
         * We want to keep track of advertiseCallBack.
         * It is needed to stop old Adv before starting new ones
         * */
        if (mInstance==null){
            mInstance=new BluetoothHelper();
            mInstance.mAdvertiseCallback=null;
        }
        return  mInstance;
    }

    public static Intent getIntentForStartingBluetooth(){
        return new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    }

    public boolean isAdvertising() {
        return isAdvertising;
    }

    private static byte[] getEncodedManufacturingData(String orderId, String boxAuth) {
        String payloadString=orderId+";"+boxAuth;
        Log.d("BLE", "payloadString "+payloadString);
        return payloadString.getBytes(Charset.forName("UTF-8"));
    }

    public boolean isBluetoothEnabled() {
        if (mBluetoothAdapter==null) {
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }
        return mBluetoothAdapter.isEnabled();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void stopAdvertisement(){
        Log.d("BLE", "Stopping the Advertisement");

        if(mAdvertiser!=null && mAdvertiseCallback!=null){
            mAdvertiser.stopAdvertising(mAdvertiseCallback);
        }
        isAdvertising = false;
    }
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public boolean startAdvertisement(String orderId, String boxAuth) {
        boolean started=false;
        if (mBluetoothAdapter==null) {
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }

        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            Log.i("BLE", "Bluetooth is not enabled");
            return started;
        }

        if (mAdvertiser==null) {
            mAdvertiser = mBluetoothAdapter.getBluetoothLeAdvertiser();
            getIntentForStartingBluetooth();
        }
        if (mAdvertiseCallback!=null ){
            mAdvertiser.stopAdvertising(mAdvertiseCallback);
        }
        AdvertiseSettings settings = new AdvertiseSettings.Builder()
                .setAdvertiseMode( AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
                .setTxPowerLevel( AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
                .setConnectable(false)
                .build();

        AdvertiseData data = new AdvertiseData.Builder()
                .setIncludeDeviceName( true )
                .addManufacturerData(CHANGEPAY_COMPANY_ID,getEncodedManufacturingData(orderId, boxAuth))
                .build();

        AdvertiseCallback advertisingCallback = new AdvertiseCallback() {
            @Override
            public void onStartSuccess(AdvertiseSettings settingsInEffect) {
                super.onStartSuccess(settingsInEffect);
                Log.i("BLE", "LE Advertise success.");
            }
            @Override
            public void onStartFailure(int errorCode) {
                Log.e("BLE", "Advertising onStartFailure: " + errorCode);
                super.onStartFailure(errorCode);
            }

        };
        Log.d("BLE", "Here");
        mAdvertiseCallback=advertisingCallback;
        mAdvertiser.startAdvertising( settings, data, advertisingCallback );

        started=true;
        isAdvertising=true;
        Log.d("BLE", "start advertising");
        return started;
    }
}
