#include <ArduinoBLE.h>

#define BUZZER_PIN 3

// Define UUIDs for the BLE service and characteristic
const char* serviceUuid = "12345678-1234-5678-1234-56789abcdef0";
const char* characteristicUuid = "12345678-1234-5678-1234-56789abcdef1";

BLEService sensorService(serviceUuid); // Create a BLE service
BLEIntCharacteristic sensorValueCharacteristic(characteristicUuid, BLERead | BLENotify);

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(9600);

  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setLocalName("Sensor Device");
  BLE.setAdvertisedService(sensorService);

  // Add the characteristic to the service
  sensorService.addCharacteristic(sensorValueCharacteristic);

  // Add service
  BLE.addService(sensorService);

  // Start advertising
  BLE.advertise();

  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  BLEDevice central = BLE.central();

  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());

    while (central.connected()) {
      int sensorValue = analogRead(A0);
      Serial.println(sensorValue);
      
      // Update characteristic with the current sensor value
      sensorValueCharacteristic.writeValue(sensorValue);
      
      if (sensorValue > 30) {
        analogWrite(BUZZER_PIN, 50);
      } else {
        analogWrite(BUZZER_PIN, 0);
      }
      
      delay(1000); // Delay to limit data rate (adjust as necessary)
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}
