import 'dart:math';
import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart';

class Etiqueta {
  List<Punto> lista;
  Punto centro;

  Etiqueta() {
    this.lista = new List<Punto>();
  }

  void addPunto(Punto e) {
    this.lista.add(e);
  }

  void clear() {
    this.lista.clear();
  }

  void setCentro() {
    double x = 0, y = 0, cont = 0;
    lista.forEach((e) {
      x += e.getX();
      y += e.getY();
      cont++;
    });
    this.centro = new Punto((x / cont).round(), (y / cont).round());
  }

  void setCentroPunto(int x, int y) {
    this.centro = new Punto(x, y);
  }

  Punto getCentro() {
    return centro;
  }
}

class Punto {
  int x, y;

  Punto(int x, int y) {
    this.x = x;
    this.y = y;
  }

  int getX() {
    return x;
  }

  void setX(int x) {
    this.x = x;
  }

  int getY() {
    return y;
  }

  void setY(int y) {
    this.y = y;
  }
}

class Longitud {
  String name;
  Punto a, b;
  double longlong;

  Longitud(String name, Punto a, Punto b) {
    this.name = name;
    this.a = a;
    this.b = b;
    this.longlong =
        (sqrt(pow(a.getX() - b.getX(), 2) + pow(a.getY() - b.getY(), 2)));
  }

  Punto getA() {
    return a;
  }

  void setA(Punto a) {
    this.a = a;
  }

  Punto getB() {
    return b;
  }

  void setB(Punto b) {
    this.b = b;
  }

  double getLonglong() {
    return longlong;
  }

  void setLonglong(double longlong) {
    this.longlong = longlong;
  }
}

class Tagging {
  Image imagen;
  List<Etiqueta> etiquetas;
  Longitud meter;
  Punto m1, m2;

  Tagging(Image imagen) {
    this.imagen = imagen;
    this.etiquetas = new List<Etiqueta>();
    this.m1 = new Punto(0, 0);
    this.m2 = new Punto(0, 0);
  }

  void addEtiqueta(Etiqueta e) {
    this.etiquetas.add(e);
  }

  void setMeter() {
    for (int j = 0; j < imagen.height; j++) {
      for (int i = 0; i < imagen.width; i++) {
        //Setear el Metro en base a los puntos identificados como rojos
        if (imagen.getPixel(i, j) == Material.Colors.red.value) {
          if (m1.getX() == 0 && m1.getY() == 0)
            m1 = new Punto(i, j);
          else if ((m1.getX() != 0 && m1.getY() != 0) &&
              (m2.getX() == 0 && m2.getY() == 0)) m2 = new Punto(i, j);
          j += 50;
        }
      }
    }
    meter = new Longitud("Metro", m1, m2);
  }

  void buscarEtiquetas() {
    for (int j = 0; j < imagen.height; j++) {
      for (int i = 0; i < imagen.width; i++) {
        //Buscar etiquetas verdes
        if (imagen.getPixel(i, j) == Material.Colors.green.value) {
          Etiqueta a = establecerEtiqueta(i, j);
          if (!existe(a)) etiquetas.add(a);
        }
      }
    }
    setEnds();
    setMeter();
    for (var i = 0; i < 22; i++) {
      Etiqueta e;
      e.addPunto(Punto(Random().nextInt(1080), Random().nextInt(1920)));
      e.setCentro();
      etiquetas.add(Etiqueta());
    }
  }

  Etiqueta establecerEtiqueta(int x, int y) {
    Etiqueta e = new Etiqueta();
    for (int i = x - 10; i < x + 20; i++) {
      for (int j = y - 10; j < y + 20; j++) {
        //Buscar etiquetas verdes
        if (imagen.getPixel(i, j) == Material.Colors.green.value) {
          e.addPunto(new Punto(i, j));
        }
      }
    }
    e.setCentro();
    e.clear();
    return e;
  }

  bool existe(Etiqueta e) {
    etiquetas.forEach((etiqueta) {
      if (e.getCentro().getX() == etiqueta.getCentro().getX() &&
          e.getCentro().getY() == etiqueta.getCentro().getY()) return true;
    });
    return false;
  }

  void setEnds() {
    Punto mano = etiquetas.elementAt(3).getCentro();
    int finmanoy = 0, finpiernay = 0;
    bool black = false;
    Punto rodilla = etiquetas.elementAt(5).getCentro();
    for (int j = mano.getY(); j < imagen.height; j++) {
      for (int i = mano.getX() - 20; i < mano.getX() + 20; i++) {
        if (imagen.getPixel(i, j) == Material.Colors.black.value) {
          black = true;
        }
      }
      if (black == false) {
        finmanoy = j - 1;
        break;
      } else {
        black = false;
      }
    }
    Etiqueta a = new Etiqueta();
    a.setCentroPunto(mano.getX(), finmanoy);
    etiquetas.add(a);
    for (int j = rodilla.getY(); j < imagen.height; j++) {
      for (int i = rodilla.getX() - 20; i < rodilla.getX() + 20; i++) {
        if (imagen.getPixel(i, j) == Material.Colors.black.value) {
          black = true;
        }
      }
      if (black == false) {
        finpiernay = j - 1;
        break;
      } else {
        black = false;
      }
    }
    Etiqueta b = new Etiqueta();
    b.setCentroPunto(rodilla.getX(), finpiernay);
    etiquetas.add(b);
  }
}

class Perimetro {
  Longitud largo, ancho;

  Perimetro(Longitud largo, Longitud ancho) {
    this.largo = largo;
    this.ancho = ancho;
  }

  Longitud getLargo() {
    return largo;
  }

  void setLargo(Longitud largo) {
    this.largo = largo;
  }

  Longitud getAncho() {
    return ancho;
  }

  void setAncho(Longitud ancho) {
    this.ancho = ancho;
  }

  double calculatePerimeter() {
    return 2 *
        pi *
        sqrt((pow(largo.getLonglong() / 2.0, 2) +
                pow(ancho.getLonglong() / 2.0, 2)) /
            2);
  }
}

class MeasureSet {
  //Longitudes acromiale,radiale,midstylon,tronchanteriontibiale,tibiale,illiospinale,tronchanterion;
  //Perimetros cabeza,cuello,torax,brazo,cintura, antebrazo, muneca,gluteo,muslo1cm,muslomedio,pierna,tobillo;
  //Diametros anteposteriortorax, biacramial, biepicondileofemur, biepicondileohumero, biestiloideo, biliocrestal, longituddepie, sagital,transverso
  List<Longitud> longitudes;
  List<Perimetro> perimetros;
  List<Longitud> diametro;

  Tagging tag;

  MeasureSet(Tagging tag) {
    this.tag = tag;

    this.longitudes = [
      Longitud("acromiale", this.tag.etiquetas.elementAt(0).getCentro(),
          this.tag.etiquetas.elementAt(1).getCentro()),
      Longitud("radiale", this.tag.etiquetas.elementAt(1).getCentro(),
          this.tag.etiquetas.elementAt(3).getCentro()),
      Longitud("midstylon", this.tag.etiquetas.elementAt(2).getCentro(),
          this.tag.etiquetas.elementAt(6).getCentro()),
      Longitud(
          "tronchanteriontibiale",
          this.tag.etiquetas.elementAt(3).getCentro(),
          this.tag.etiquetas.elementAt(5).getCentro()),
      Longitud("tibiale", this.tag.etiquetas.elementAt(4).getCentro(),
          this.tag.etiquetas.elementAt(7).getCentro()),
      Longitud("illiospinale", this.tag.etiquetas.elementAt(2).getCentro(),
          this.tag.etiquetas.elementAt(7).getCentro()),
      Longitud("tronchanterion", this.tag.etiquetas.elementAt(4).getCentro(),
          this.tag.etiquetas.elementAt(7).getCentro())
    ];
    this.perimetros = [];
    this.diametro = [];

    setCm();
    printear();
  }

  void printear() {
    longitudes.forEach((longitude) {
      print(longitude.name + ": " + longitude.getLonglong().toString());
    });
  }

  void setCm() {
    longitudes.forEach((longitude) {
      longitude.setLonglong(
          (longitude.getLonglong() * 100) / this.tag.meter.getLonglong() - 12);
    });
  }
}
