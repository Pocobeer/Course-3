#include "Light.h"

Light::Light() :
	position(vec4(0.0f, 0.0f, 0.0f, 1.0f)),
	ambient(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	diffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	specular(vec4(1.0f, 1.0f, 1.0f, 1.0f)) {};

Light::Light(vec3 position) :
	position(vec4(position, 1.0f)),
	ambient(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	diffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	specular(vec4(1.0f, 1.0f, 1.0f, 1.0f)) {};

Light::Light(float x, float y, float z):
	position(vec4(position, 1.0f)),
	ambient(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	diffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	specular(vec4(1.0f, 1.0f, 1.0f, 1.0f)) {};

void Light::setPosition(vec3 position) {
	this->position = vec4(position, 1.0f);
}

void Light::setAmbient(vec4 color) {
	ambient = color;
}

void Light::setDiffuse(vec4 color) {
	diffuse = color;
}

void Light::setSpecular(vec4 color) {
	specular = color;
}

void Light::apply(GLenum LightNumber) {
	glLightfv(LightNumber, GL_POSITION, value_ptr(position));
	glLightfv(LightNumber, GL_AMBIENT, value_ptr(ambient));
	glLightfv(LightNumber, GL_DIFFUSE, value_ptr(diffuse));
	glLightfv(LightNumber, GL_SPECULAR, value_ptr(sprcular));
}