//se incluye libreria externa para leer el sensor de peso
#include "HX711.h"

HX711 balanza;

//Declaración de Pines
//pines analogos para la balanza
const int CLK = A0;
const int DOUT = A1;

//pines digitales para sensor ultrasonico
const int trigPin = 11;
const int echoPin = 12;
const int ledPin = 13;

//pines digitales para sensores de proximidad
const int sensor_trasero = 10;
const int sensor_delantero = 9;

const int indicador_peso = 8;

//pin digital para simular solicitud de nivel de desinfectante
const int lectura_nivel = 4;

boolean puerta_trasera_abierta = false;
boolean puerta_delantera_abierta = false;
boolean objeto_rociado;


void setup() {
  Serial.begin(9600);

  //modo de pines de sensor ultrasonico
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ledPin, OUTPUT);

  //modo de pines de sensores de proximidad
  pinMode(sensor_trasero,INPUT);
  pinMode(sensor_delantero,INPUT);

  //modo del pin del boton que simula solicitud de lectura de nivel
  pinMode(lectura_nivel,INPUT);
  
  pinMode(indicador_peso, OUTPUT);

  //inicializacion de la balanza
  balanza.begin(DOUT, CLK);
  Serial.print("Lectura del valor del ADC:  ");
  Serial.println(balanza.read());
  Serial.println("No ponga ningun  objeto sobre la balanza");
  Serial.println("Destarando...");
  Serial.println("...");
  balanza.set_scale(995); // Establecemos la escala
  balanza.tare(20);  //El peso actual es considerado Tara.
  
  Serial.println("Listo para pesar");
}

void loop() {
  //lectura continua de sensores de proximidad, trasero, delantero
  puerta_trasera_abierta = digitalRead(sensor_trasero);
  puerta_delantera_abierta = digitalRead(sensor_delantero);

  if (puerta_trasera_abierta == true){
    objeto_rociado = false;
  }
  
  //lectura continua del peso
  if (balanza.get_units(20) > 50 && puerta_trasera_abierta == false && puerta_delantera_abierta == false && objeto_rociado == false){
    digitalWrite(indicador_peso, HIGH);
    //rociador 1 (durante 3 segundos)
    //rociador 0
    objeto_rociado = true;
  }else{
    digitalWrite(indicador_peso, LOW);
  }

  
  if(digitalRead(lectura_nivel) == HIGH){
    int resultado = Deteccion_nivel();
    //hacer algo con la variable resultado
    Serial.println(resultado);
  }

  delay(200);
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

  /*
  if(distance >= 200 || distance <= 0){
    Serial.println("Fuera de rango");
  }
  else{
    Serial.print(distance);
    Serial.println(" cm");
  }
  */

  /*
  if(distance > 3 && distance <= 11){
    digitalWrite(nivel_alto, HIGH);
    digitalWrite(nivel_medio, LOW);
    digitalWrite(nivel_bajo, LOW);
  }else if(distance > 11 && distance <= 15){
    digitalWrite(nivel_alto, LOW);
    digitalWrite(nivel_medio, HIGH);
    digitalWrite(nivel_bajo, LOW);
  }else if (distance > 15 && distance <= 16){
    digitalWrite(nivel_alto, LOW);
    digitalWrite(nivel_medio, LOW);
    digitalWrite(nivel_bajo, HIGH);
  }else{
    digitalWrite(nivel_alto, HIGH);
    digitalWrite(nivel_medio, HIGH);
    digitalWrite(nivel_bajo, HIGH);
  }
  */

  if(distance > 3 && distance <= 11){
    //si la distancia del sensor al agua es de entre 3 y 11 cm retorna valor alto (2)
    return 2;
  }else if(distance > 11 && distance <= 15){
    //si la distancia del sensor al agua es de entre 11 y 15 cm retorna valor medio (1)
    return 1;
  }else if (distance > 15 && distance <= 25){
    //si la distancia del sensor al agua es de entre 15 y 25 cm retorna valor bajo (0)
    return 0;
  }else{
    //si la distancia devuelve algun valor fuera de rango devuelve indefinido (-1)
    return -1;
  }
}
