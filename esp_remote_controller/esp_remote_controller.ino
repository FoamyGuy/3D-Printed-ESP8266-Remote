/*
 *  This sketch joins a pre-defined wifi network. 
 *  It listens for button presses on IO pins 0 and 2.
 *  When a button is pressed it will send an HTTP GET request
 *  to a pre-defined URL.
 *
 */

#include <ESP8266WiFi.h>

// Fill in your own network info

const char* ssid     = "YourNetworwSSID";
const char* password = "YourNetworkPassword";



// Change the host and port to suite your needs.
const char* HOST = "192.168.1.104";
const int PORT = 5000;

// set the endpoints for each button.
String BTN_1_TRIGGER_URL = "/team2";
String BTN_0_TRIGGER_URL = "/team1";

String BTN_1_LONG_PRESS_TRIGGER_URL = "/team2minus";
String BTN_0_LONG_PRESS_TRIGGER_URL = "/team1minus";

// endpoint for hello action. Gets called once at end of startup.
 String HELLO_URL = "/hello";

int BTN_1_PIN = 2;
int BTN_0_PIN = 0;

int BTN_1_PREV = HIGH;
int BTN_0_PREV = HIGH;


unsigned long BTN_1_DOWN_TIME = 0;
unsigned long BTN_0_DOWN_TIME = 0;

unsigned long time_of_press = 0;
unsigned long cur_time = 0;

void http_get(const char* host, int port, String url){
     // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = port;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
  Serial.print("Requesting URL: ");
  Serial.println(url);
  
  // This will send the request to the server
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
  delay(10);
  
  // Read all the lines of the reply from server and print them to Serial
  while(client.available()){
    String line = client.readStringUntil('\r');
    Serial.print(line);
  }
  
  Serial.println();
  Serial.println("closing connection");
}

void setup() {
  Serial.begin(115200);
  delay(10);

  // We start by connecting to a WiFi network

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  pinMode(BTN_1_PIN, INPUT_PULLUP);
  pinMode(BTN_0_PIN, INPUT_PULLUP);

  // say hi
  if (HELLO_URL != ""){
    http_get(HOST, PORT, HELLO_URL);
  }
  
}

void loop() {
  int cur1 = digitalRead(BTN_1_PIN);
  int cur0 = digitalRead(BTN_0_PIN);

  /* 
   *  check if buttons were pressed down 
   */
  if ((cur1 == LOW) && (BTN_1_PREV == HIGH)){
    time_of_press = millis();
    BTN_1_DOWN_TIME = time_of_press;
  }

  if ((cur0 == LOW) && (BTN_0_PREV == HIGH)){
    time_of_press = millis();
    BTN_0_DOWN_TIME = time_of_press;
  }

  /*
   * check if buttons were released
   */

  if ((cur1 == HIGH) && (BTN_1_PREV == LOW)){
    // Determine if long press or short press
    cur_time = millis();
    if((cur_time - BTN_1_DOWN_TIME) < 750){
      http_get(HOST, PORT, BTN_1_TRIGGER_URL);
    }
  }

  if ((cur0 == HIGH) && (BTN_0_PREV == LOW)){
    // Determine if long press or short press
    cur_time = millis();
    if((cur_time - BTN_0_DOWN_TIME) < 750){
      http_get(HOST, PORT, BTN_0_TRIGGER_URL);
    }
  }

  /* Check if buttons have been held down 
   *  
   */

   cur_time = millis();
   
   if ((cur0==LOW) && ((cur_time - BTN_0_DOWN_TIME) > 750)){
      http_get(HOST, PORT, BTN_0_LONG_PRESS_TRIGGER_URL);
   }
   if ((cur1==LOW) && ((cur_time - BTN_1_DOWN_TIME) > 750)){
      http_get(HOST, PORT, BTN_1_LONG_PRESS_TRIGGER_URL);
   }


  BTN_1_PREV = cur1;
  BTN_0_PREV = cur0;
  delay(100);
}

