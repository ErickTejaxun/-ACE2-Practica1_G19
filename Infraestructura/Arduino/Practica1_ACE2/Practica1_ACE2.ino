#include "HX711.h"
#include <SoftwareSerial.h>

HX711 balanza;
SoftwareSerial mySerial(5, 6); // RX, TX

const int echoPin = 12;
const int trigPin = 11;
const byte pin_puerta_trasera = 10;
const byte pin_puerta_delantera = 9;
const byte pin_bomba = 7;

const int DOUT=A1;
const int CLK=A0;

boolean puerta_abierta_trasera;
boolean puerta_abierta_delantera;

boolean objeto_rociado;

void setup() {
  Serial.begin(9600);
  mySerial.begin(115200);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  pinMode(pin_puerta_trasera, INPUT);
  pinMode(pin_puerta_delantera, INPUT);

  pinMode(pin_bomba, OUTPUT);

  calibracion_balanza();
}

void loop() {
  //String b = estado_puertas();
  //byte c = estado_puertas2();
  float d = lectura_balanza();
  int nivel = Deteccion_nivel();
  //float nivel = Deteccion_nivel2();

  puerta_abierta_trasera = digitalRead(pin_puerta_trasera);
  puerta_abierta_delantera = digitalRead(pin_puerta_delantera);

  Serial.println(estado_puertas(puerta_abierta_trasera, puerta_abierta_delantera));

  if (nivel == 2){
    Serial.print("Nivel del tanque: ");
    Serial.print(nivel);
    Serial.println(", nivel Alto");
  }else if (nivel == 1){
    Serial.print("Nivel del tanque: ");
    Serial.print(nivel);
    Serial.println(", nivel Medio");
  }else if (nivel == 0){
    Serial.print("Nivel del tanque: ");
    Serial.print(nivel);
    Serial.println(", nivel Bajo");
  }
  

  if (puerta_abierta_trasera == true || puerta_abierta_delantera == true){
    objeto_rociado = false;
    
  }

  if (d > 25){
    Serial.print("Objeto presente, el peso es: ");
    Serial.println(d);  
  }
  
  
  if (puerta_abierta_trasera == false && puerta_abierta_delantera == false && d > 25 && objeto_rociado == false){
    activar_bomba();
    objeto_rociado = true;
  }

  mySerial.println(String(int(d))+String(";")+String(nivel)+String("."));

  delay(300);
}


String estado_puertas(boolean puerta_abierta_trasera, boolean puerta_abierta_delantera){
  //puerta_abierta_trasera = digitalRead(pin_puerta_trasera);
  //puerta_abierta_delantera = digitalRead(pin_puerta_delantera);

  String a;

  if (puerta_abierta_trasera == 1){
    //Serial.println("Puerta trasera abierta");
    a = "Puerta trasera abierta ";
  }else if(puerta_abierta_trasera == 0){
    //Serial.println("Puerta trasera cerrada");
    a = "Puerta trasera cerrada ";
  }

  if (puerta_abierta_delantera == 1){
    //Serial.println("Puerta delantera abierta");
    a = a + ", Puerta delantera abierta";
  }else if(puerta_abierta_delantera == 0){
    //Serial.println("Puerta delantera cerrada");
    a = a + ", Puerta delantera cerrada";
  }

  return a;  
}

byte estado_puertas2(){
  puerta_abierta_trasera = digitalRead(pin_puerta_trasera);
  puerta_abierta_delantera = digitalRead(pin_puerta_delantera);

  byte resultado;

  if (puerta_abierta_trasera == 0 && puerta_abierta_delantera == 0){
    resultado = 0;
  }else if (puerta_abierta_trasera == 1 && puerta_abierta_delantera == 0){
    resultado = 1;
  }else if (puerta_abierta_trasera == 0 && puerta_abierta_delantera == 1){
    resultado = 2;
  }else if (puerta_abierta_trasera == 1 && puerta_abierta_delantera == 1){
    resultado = 3;
  }

  return resultado;
}


void calibracion_balanza(){
  balanza.begin(DOUT, CLK);
  Serial.print("Lectura del valor del ADC:  ");
  Serial.println(balanza.read());
  Serial.println("No ponga ningun  objeto sobre la balanza");
  Serial.println("Destarando...");
  Serial.println("...");
  balanza.set_scale(987); // Establecemos la escala
  balanza.tare(20);  //El peso actual es considerado Tara.  
}

float lectura_balanza(){
    return balanza.get_units(20);
}


int Deteccion_nivel(){
  //lectura de distancia del sensor hacia el agua
  float duration, distance;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  distance = (duration / 58.2);


  if(distance > 0 && distance <= 13){
    //si la distancia del sensor al agua es de entre 3 y 11 cm retorna valor alto (2)
    return 2;
  }else if(distance > 13 && distance <= 20){
    //si la distancia del sensor al agua es de entre 11 y 15 cm retorna valor medio (1)
    return 1;
  }else if (distance > 20 && distance < 35){
    //si la distancia del sensor al agua es de entre 15 y 25 cm retorna valor bajo (0)
    return 0;
  }else{
    //si la distancia devuelve algun valor fuera de rango devuelve indefinido (-1)
    return -1;
  }
}


float Deteccion_nivel2(){
  //lectura de distancia del sensor hacia el agua
  float duration, distance;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  distance = (duration / 58.2);

  return distance;
}


void activar_bomba(){
  digitalWrite(pin_bomba, HIGH); // envia señal alta al relay
  delay(2000);
  
  digitalWrite(pin_bomba, LOW);  // envia señal baja al relay
  Serial.println("OBJETO ROCIADO");
}
