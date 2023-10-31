import 'package:flutter/material.dart';

Padding createCard(sallesMap, el, color, until) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(sallesMap[el]["batiment"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17)),
                          AnimatedContainer(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.8),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: Icon(Icons.circle, color: color, size: 18),
                          )
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(sallesMap[el]["salle"],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ]),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(until,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                  ]),
                ],
              ))));
}
