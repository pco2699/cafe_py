#include <DHT.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

// 温度湿度センサー
const int DHT_PIN  = 4;    // ESP-WROOM-02 の GPIO12 を温湿度センサー入力とする
const int DHT_TYPE = DHT22; // DHT11/DHT21/DHT22/AM2301 (DHT21/DHT22/AM2301 センサーを使うならばそちらを指定)

const char* HTTP_HOST = "192.168.0.6:5000";

//ご自分のルーターのSSIDを入力してください
const char* ssid = "Buffalo-G-D86F";
//ご自分のルーターのパスワード
const char* password = "scdndi7reuarn";



WiFiClient client;

// センサー初期化
DHT dht(DHT_PIN, DHT_TYPE);

// 計測値
float temperature = 0.0f;  // 温度
float humidity    = 0.0f;  // 湿度
float heatIndex   = 0.0f;  // 体感温度的な暑さ指数 see http://www.nws.noaa.gov/om/heat/heat_index.shtml
int   discomfortIndex = 0; // 不快指数

int computeDiscomfortIndex(float t, float h);

void setup() {
  Serial.begin(115200);
  // Connect to WiFi network
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
  delay(10);

  // 温度湿度センサー開始
  dht.begin();

}

void loop() {
  // 温度や湿度の読み出しに約 250ms かかります！
  // センサーの測定値もまた最大2秒古い値が返ってきます（このセンサーはとても遅いのです...）
  // ゆえに 2 秒待ちましょう
  delay(60000);

  // 温度(セ氏)を読み取ります
  temperature = dht.readTemperature();
  // 湿度(%)を読み取ります
  humidity = dht.readHumidity();

  

  // 読み取れたかチェックします
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  heatIndex = dht.computeHeatIndex(temperature, humidity, false);
  // 不快指数
  discomfortIndex = computeDiscomfortIndex(temperature, humidity);

  // HTTPで送付
  HTTPClient http;

  char url[128];
  sprintf(url, "http://%s/api/v1/temps/add", HTTP_HOST);
  http.begin(url);

  // ThingSpeak API キーはヘッダーに
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");

  // POST パラメータ作る
  char params[128];
  char tempstr[4];
  char humistr[4];
  sprintf(params, "temp=%s&humid=%s", dtostrf(temperature, 1, 0, tempstr), dtostrf(humidity, 1, 0, humistr));
  // POST リクエストする
  int httpCode = http.POST(params);

  if (httpCode > 0) {
    // HTTP レスポンスコードが返ってくる
    Serial.printf("[HTTPS] POST... code: %d\n", httpCode);
  } else {
    // コネクションエラーになるとマイナスが返る
    // see https://github.com/esp8266/Arduino/blob/master/libraries/ESP8266HTTPClient/src/ESP8266HTTPClient.h
    // HTTP client errors
    Serial.println("[HTTPS] no connection or no HTTP server.");
  }

  http.end();
 
  // 読み取った値をシリアル出力
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print("°C\t");
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("%\t");
  Serial.print("Heat Index: ");
  Serial.print(heatIndex);
  Serial.print("°C\t");
  Serial.print("Discomfort Index: ");
  Serial.println(discomfortIndex);
}

int computeDiscomfortIndex(float t, float h) {
  int index;
  // see https://ja.wikipedia.org/wiki/%E4%B8%8D%E5%BF%AB%E6%8C%87%E6%95%B0
  // 0.81T+0.01H(0.99T-14.3)+46.3
  index = 0.81f * t + 0.01f * h * (0.99f * t - 14.3f) + 46.3f;

  return index;
}
