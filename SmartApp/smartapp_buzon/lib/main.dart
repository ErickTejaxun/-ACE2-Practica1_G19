// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;

var url_tanque = 'https://v4cr3oicvj.execute-api.us-east-2.amazonaws.com/fase1/tanque';
var url_peso = 'https://v4cr3oicvj.execute-api.us-east-2.amazonaws.com/fase1/peso';
var titulos =  ['Estado del buzón','Peso del objeto','Nivel líquido en el tanque'];
var colores = [Colors.green, Colors.blue, Colors.blue];
var estados_contenedor = ['Alto: Mayor del 50%', 'Medio: Debajo del 50%', 'Bajo: El tanque está casi vacío'];
var colores_estado_contendores= [Colors.green, Colors.yellow, Colors.red];
var estados_variables = [0,50,0]; // Nivel del líquido del tanque, Estado del buzón, Peso del objeto
var estado_buzon = ['Vacío', 'Lleno'];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: 'Smart MailBox Grupo 19',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Smart MailBox Grupo 19'),
        ),
        body: Center(
          //child: RandomWords(),
          child: BuzonBodyWidget(),    
        ),
      ),
    );
  }
}

class BuzonBodyWidget extends StatelessWidget
{
  @override 
  Widget build(BuildContext context)
  {
    return Column
    (
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,    
      crossAxisAlignment: CrossAxisAlignment.start,  
      children:
      [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: BuzonWidget(indiceElemento: 0),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: BuzonWidget(indiceElemento: 1),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: BuzonWidget(indiceElemento: 2),
        ),                
      ]
    );
  }
}


class BuzonWidget extends StatelessWidget 
{
  BuzonWidget({this.indiceElemento});
  final int indiceElemento;

  
  @override
  Widget build(BuildContext context) {
    Color colorFondo = Colors.white;      
    Titulo mensaje_= Titulo(tamanioFuente: 2, texto:titulos[indiceElemento]);    
    switch(indiceElemento)
    {
      case 0:
        //colorFondo = colores_estado_contendores[estados_variables[2]];    
        mensaje_ = Titulo(tamanioFuente: 2, texto: estado_buzon[estados_variables[0]]);
      break;
      case 1:
        //colorFondo = colores_estado_contendores[estados_variables[0]];    
        mensaje_ = Titulo(tamanioFuente: 2, texto: estados_variables[1].toString() + ' Kg.');
      break;            
      case 2:
        colorFondo = colores_estado_contendores[estados_variables[0]];    
        mensaje_ = Titulo(tamanioFuente: 2, texto: estados_contenedor[estados_variables[0]]);
      break;
    }



    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,      
      children: [
        Flexible
        (
          fit: FlexFit.tight,
          flex: 1,
          child: Apartado(colorFondo:colorFondo , widget: Elemento(titulo: Titulo(tamanioFuente: 1, texto:titulos[indiceElemento]), mensaje: mensaje_) ),
        ),        
      ],
    );
  }
}

class Apartado extends StatelessWidget {
  Apartado({this.widget, this.colorFondo});
  final Widget widget;  
  final Color colorFondo;

  @override
  Widget build(BuildContext context) {    
    return Container(
      width: 300,
      height: 150,
      decoration: BoxDecoration(
        color: colorFondo,
        border: Border.all(),
      ),
      child: widget,      
    );
  }
}

class Titulo extends StatelessWidget
{
    Titulo({this.texto, this.tamanioFuente});
    final String texto;
    final int tamanioFuente;
    @override 
    Widget build(BuildContext context)
    {
      if(tamanioFuente==2)
      {
        return 
          Text(texto,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black));  
      }else
      {
        return 
        Text(texto,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Colors.black));            
      }
      
    }
}


class Elemento extends StatelessWidget
{
  Elemento({this.titulo,this.mensaje});
  final Widget titulo;
  final Widget mensaje;  

  @override
  Widget build(BuildContext context) 
  {
    return Column
    (
      children: [ titulo,mensaje]      
    );
  }

}