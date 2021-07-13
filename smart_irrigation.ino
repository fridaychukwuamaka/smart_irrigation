#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#endif

#include "DHT.h"
//here we use 14 of ESP32 to read data
#define DHTPIN A13
//our sensor is DHT11 type
#define DHTTYPE DHT11
//create an instance of DHT sensor
DHT dht(DHTPIN, DHTTYPE);


//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

const int AirValue = 4095;   //you need to replace this value with Value_1
const int WaterValue = 1880;  //you need to replace this value with Value_2
int soilMoistureValue = 0;
int soilmoisturepercent = 0;
bool isRaining = false;
float f;
int waterGuage = 5;

#define FIREBASE_HOST ""              // the project name address from firebase id
#define FIREBASE_AUTH ""       // the secret key generated from firebase
#define WIFI_SSID "Moto G Play"
#define WIFI_PASSWORD "wewhere1"




void setup() {
  dht.begin();
  connectWifi();
  pinMode(waterGuage,INPUT_PULLUP);
}

void loop() {
  readUpdateMoistureData();

  readUpdateRainData();

  getReservoirLevel();

  //use the functions which are supplied by library.
  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();


  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  // print the result to Terminal
  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.println(" *C ");

  //converting degree to farenheit
  f = t * (9 / 5) + 32;

  Firebase.setFloat(fbdo , "humidity", h);

  Firebase.setFloat(fbdo , "temperature", f);
  //we delay a little bit for next read
  delay(2000);
}


void readUpdateMoistureData() {
  soilMoistureValue = analogRead(36);  //put Sensor insert into soil

  soilmoisturepercent = map(soilMoistureValue, AirValue, WaterValue, 0, 100);
  Serial.println(soilmoisturepercent);
  Firebase.setInt(fbdo, "moisture_sensor/value", soilmoisturepercent);
  if (soilmoisturepercent >= 100)
  {
    Serial.println("100 %");
  }
  else if (soilmoisturepercent <= 0)
  {
    Serial.println("0 %");
  }
  else if (soilmoisturepercent > 0 && soilmoisturepercent < 100)
  {
    Serial.print(soilmoisturepercent);
    Serial.println("%");

  }
  delay(1000);
}

void readUpdateRainData() {
  int waterSensorValue = analogRead(32);  //put Sensor insert into soil

  Serial.println(waterSensorValue);

  if (waterSensorValue <= 2500)
  {
    Firebase.setBool(fbdo, "rain", true);
    isRaining = true;
  }
  else
  {
    Firebase.setBool(fbdo, "rain", false);
    isRaining = false;
  }
  delay(1000);
}

void getReservoirLevel(){
  if(digitalRead(waterGuage) ==HIGH ){
     Serial.println("Water yes");
       Firebase.setBool(fbdo, "water_level", true);
  }else{
    Serial.println("Water no"); 
     Firebase.setBool(fbdo, "water_level", false);
  }

  delay(2000);
}


void connectWifi() {
  Serial.begin(9600);
  delay(1000);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); // connect to firebase
  Firebase.reconnectWiFi(true);
}
