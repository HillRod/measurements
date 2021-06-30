import 'dart:math';
import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart';
import 'dart:io';
import 'dart:ui' as F;

/*Future<Image> gaussProcess(File f) async {
  Image image = decodeImage(f.readAsBytesSync());
  
  dynamic gausblur = await ImgProc.gaussianBlur(f.readAsBytesSync(), [5,5], 0);
  return Image.fromBytes(image.width, image.height, gausblur);
}*/

void segmentHSV(String path) {
  print(path);
  List<double> mingreenHSV = [100.0, 80.0, 70.0], maxgreenHSV = [185, 255, 255];
  List<double> minblueHSV = [210.0, 80.0, 70.0], maxblueHSV = [250, 255, 255];
  Image image = decodeImage(File(path).readAsBytesSync());
  print(image.width);
  print(image.height);
  for (var i = 0; i < image.width; i++) {
    for (var j = 0; j < image.height; j++) {
      F.Color c = F.Color(image.getPixel(i, j));
      List<double> cHSV = rgb_to_hsv(c.red.ceilToDouble() / 255,
          c.green.ceilToDouble() / 255, c.blue.ceilToDouble() / 255);
          //if green
      if ((cHSV[0] >= mingreenHSV[0] && cHSV[0] <= maxgreenHSV[0]) &&
          (cHSV[1] >= mingreenHSV[1] && cHSV[1] <= maxgreenHSV[1]) &&
          (cHSV[2] >= mingreenHSV[2] && cHSV[2] <= maxgreenHSV[2]))
        image.setPixel(i, j, Material.Colors.white.value);
          //else
      else if ((cHSV[0] >= minblueHSV[0] && cHSV[0] <= maxblueHSV[0]) &&
          (cHSV[1] >= minblueHSV[1] && cHSV[1] <= maxblueHSV[1]) &&
          (cHSV[2] >= minblueHSV[2] && cHSV[2] <= maxblueHSV[2]))
        image.setPixel(i, j, Material.Colors.green.value);
      else
        image.setPixel(i, j, Material.Colors.black.value);
      //print(i.toString()+" "+j.toString());

    }
  }
  File(path).writeAsBytesSync(encodeJpg(image));
}

List<double> rgb_to_hsv(double r, double g, double b) {
  double maxc = max(r, max(g, b));
  double minc = min(r, min(g, b));

  double v = maxc;
  if (minc == maxc) return [0.0, 0.0, v];

  double s = (maxc - minc) / maxc;
  double rc = (maxc - r) / (maxc - minc);
  double gc = (maxc - g) / (maxc - minc);
  double bc = (maxc - b) / (maxc - minc);

  double h;
  if (r == maxc)
    h = bc - gc;
  else if (g == maxc)
    h = 2.0 + rc - bc;
  else
    h = 4.0 + gc - rc;
  h = (h / 6.0) % 1.0;
  //print([h, s, v]);
  return [h * 360, s * 255, v * 255];
}
