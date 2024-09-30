
#include "PhongMaterial.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <glm/gtc/type_ptr.hpp>
#include <fstream>
#include <sstream>
#include <iostream>


PhongMaterial::PhongMaterial() :
    ambient(vec4(0.0)),
    diffuse(vec4(0.0)),
    specular(vec4(0.0)),
    emission(vec4(0.0)),
    shininess(0.0) {}

void PhongMaterial::setAmbient(vec4 color) {
    ambient = color;
}

void PhongMaterial::setDiffuse(vec4 color) {
    diffuse = color;
}

void PhongMaterial::setEmission(vec4 color) {
    emission = color;
}

void PhongMaterial::setSpecular(vec4 color) {
    specular = color;
}

void PhongMaterial::setShininess(float p) {
    shininess = p;
}

void PhongMaterial::load(const string& filename) {
    ifstream file(filename);
    if (!file.is_open()) {
        cout << "Can't open file: " << filename << endl;
        return; // Выход из функции, если не удалось открыть файл
    }

    string line;
    while (getline(file, line)) {
        istringstream iss(line);
        string key;
        float r, g, b, a;

        if (iss >> key >> r >> g >> b >> a) {
            vec4 color(r, g, b, a);
            if (key == "ambient") {
                setAmbient(color);
            } else if (key == "diffuse") {
                setDiffuse(color);
            } else if (key == "specular") {
                setSpecular(color);
            } else if (key == "emission") {
                setEmission(color);
            } else if (key == "shininess") {
                setShininess(r); // Предполагаем, что значение shininess передается как r
            }
        }
    }
}

void PhongMaterial::apply() {
    glMaterialfv(GL_FRONT, GL_AMBIENT, value_ptr(ambient));
    glMaterialfv(GL_FRONT, GL_DIFFUSE, value_ptr(diffuse));
    glMaterialfv(GL_FRONT, GL_SPECULAR, value_ptr(specular));
    glMaterialfv(GL_FRONT, GL_EMISSION, value_ptr(emission));
    glMaterialf(GL_FRONT, GL_SHININESS, shininess);
}
