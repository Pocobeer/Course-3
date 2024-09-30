#include "PhongMaterial.h"

PhongMaterial::PhongMaterial() :
	ambient(vec4(0.0)),
	diffuse(vec4(0.0)),
	specular(vec4(0.0)),
	emission(vec4(0.0)),
	shininess(0.0) {};

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