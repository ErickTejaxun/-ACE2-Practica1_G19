#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  
  while(!Serial){
    Serial.println("."); //wait for serial port to connect
  }
  
  WiFi.begin("TURBONETT_F9AC27", "15D9352E14");   //WiFi connection
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for the WiFI connection completion
    delay(500);
    Serial.println("Waiting for connection");
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  char caracter;
  String contenido="";
  
  if(Serial.available()){
      
    while(Serial.available()){
      caracter = Serial.read();
      contenido.concat(caracter);
      delay(10);
    }

    //if (contenido != ""){
      //recibido = Serial.read();
      int punto_coma = contenido.indexOf(';');
      int fin = contenido.indexOf('.');
      String objeto = contenido.substring(0, punto_coma);
      String nivel = contenido.substring(punto_coma + 1, fin);

      //Serial.println(punto_coma);
      //Serial.println(contenido.length());


      if(WiFi.status()== WL_CONNECTED){   //Check WiFi connection status

        std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);    
        client->setInsecure();
        
        HTTPClient http;    //Declare object of class HTTPClient

        
        http.begin(*client, "https://v4cr3oicvj.execute-api.us-east-2.amazonaws.com/fase1/peso");
        http.addHeader("Content-Type", "application/json");  //Specify content-type header

        int httpCode = http.POST("{\"peso\":\"" + String(objeto) + "\"}");   //Send the request
        String payload = http.getString();   //Get the response payload

        Serial.println(httpCode);   //Print HTTP return code
        Serial.println(payload);    //Print request response payload
        
        http.end();  //Close connection

        


        http.begin(*client, "https://v4cr3oicvj.execute-api.us-east-2.amazonaws.com/fase1/tanque");
        http.addHeader("Content-Type", "application/json");  //Specify content-type header
        
        int httpCode2 = http.POST("{\"tanque\":\"" + String(nivel) + "\"}");   //Send the request
        String payload2 = http.getString();   //Get the response payload
        
        Serial.println(httpCode2);   //Print HTTP return code
        Serial.println(payload2);    //Print request response payload

        http.end();  //Close connection
        
      }else{
        Serial.println("Error in WiFi connection");   
      }
      
      //delay(10000);  //Send a request every 30 seconds


     /*
      String str = String("objeto: ")+String(objeto)+String(" nivel: ")+String(nivel);
      //Serial.write(str);
      //Serial.write(Serial.read());
      Serial.print(str);
      */
    //}
  }


  
  






}
