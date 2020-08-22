// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:smartapp_buzon/rest_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



var titulos =  ['Estado del buzón','Peso del objeto','Nivel líquido en el tanque'];
var colores = [Colors.green, Colors.blue, Colors.blue];
//var estados_contenedor = ['Alto: Mayor del 50%', 'Medio: Debajo del 50%', 'Bajo: El tanque está casi vacío'];
var estados_contenedor = ['Bajo: El tanque está casi vacío','Medio: Debajo del 50%','Alto: Mayor del 50%'];
var colores_estado_contendores= [Colors.red, Colors.yellow, Colors.green];
var estados_variables = [0,0,0]; //0: Estado del buzón, 1: Peso del objeto, 2: Estado del tanque
var estado_buzon = ['Vacío', 'Lleno'];



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  //ApiService.getDataTanque();    
  @override
  Widget build(BuildContext context) 
  {
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

class BuzonBodyWidget extends StatefulWidget
{
  @override
  _BuzonBodyStateWidget createState() => _BuzonBodyStateWidget();  
}


class _BuzonBodyStateWidget extends State<BuzonBodyWidget>
{
  int _pesoObjeto =0;
  int _estado_buzon = 0;
  int _estado_tanque = 2;
  void _actualizar() 
  {
    setState(() 
    {
      ApiService.getDataBuzon(); 
      ApiService.getDataTanque();
      _pesoObjeto = estados_variables[0];
      _estado_buzon = _pesoObjeto==0? 0:1;
      print('-----------Peso objeto\t'+_pesoObjeto.toString());
      print('-----------Estado del buzón\t'+_estado_buzon.toString());
      _estado_tanque = estados_variables[2];
    });
  }
  
  @override 
  Widget build(BuildContext context)
  {
    return Column
    (
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,    
      //crossAxisAlignment: CrossAxisAlignment.start,  
      children:
      [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: 
          Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,      
                children: [
                  Flexible
                  (
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Apartado(colorFondo:Colors.white , widget: Elemento(titulo: Titulo(tamanioFuente: 1, texto:titulos[0]), mensaje: Titulo(tamanioFuente: 2, texto: estado_buzon[_estado_buzon] ) )),
                  ),        
                ],
              ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: 
          Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,      
                children: [
                  Flexible
                  (
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Apartado(colorFondo: Colors.white , widget: Elemento(titulo: Titulo(tamanioFuente: 1, texto:titulos[1]), mensaje: Titulo(tamanioFuente: 2, texto: '$_pesoObjeto Kg.')) ),
                  ),        
                ],
              ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: 
          Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,      
                children: [
                  Flexible
                  (
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Apartado(colorFondo:colores_estado_contendores[_estado_tanque] , widget: Elemento(titulo: Titulo(tamanioFuente: 1, texto:titulos[2]), mensaje: Titulo(tamanioFuente: 2, texto: estados_contenedor[estados_variables[2]])) ),
                  ),        
                ],
              ),          
        ),   
        Flexible
        (
          fit: FlexFit.tight,
          flex: 1,
          child: FloatingActionButton(
                onPressed: _actualizar,
                tooltip: 'UpdateData',
                child: Icon(Icons.update),
              ),          
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
    ApiService.getDataBuzon();   
    ApiService.getDataTanque();
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
      case 2:/**Evaluación del estado del tanque */
        colorFondo = colores_estado_contendores[estados_variables[0]];    
        mensaje_ = Titulo(tamanioFuente: 2, texto: estados_contenedor[estados_variables[0]]);

        /*Aquí desplegamos la notificación de ser necesario */
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






class BuzonInformeWidget extends StatefulWidget
{
  BuzonInformeWidget({this.titulo});

  final String titulo;
  

  @override
  _BuzonInformerWidgetState createState() => _BuzonInformerWidgetState(); 
}

class _BuzonInformerWidgetState extends State<BuzonInformeWidget>
{
  int _nivelLiquiedo = estados_variables[0];


  void _actualizar() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      ApiService.getDataBuzon();
    });


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,      
      children: [
        Flexible
        (
          fit: FlexFit.tight,
          flex: 1,
          child: 
              Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,      
                    children: [
                      Flexible
                      (
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Apartado(colorFondo:Colors.white , widget: Elemento(titulo: Titulo(tamanioFuente: 1, texto:titulos[0]), mensaje: Titulo(tamanioFuente: 2, texto:titulos[0]))),
                      ),        
                    ],
                  ),          
        ),    
        Flexible
        (
          fit: FlexFit.tight,
          flex: 1,
          child: FloatingActionButton(
                onPressed: _actualizar,
                tooltip: 'Update Data',
                child: Icon(Icons.update),
              ),          
        ),             
      ],
    );

  }
}