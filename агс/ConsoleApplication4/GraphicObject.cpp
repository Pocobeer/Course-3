#include "GraphicObject.h"

GraphicObject::GraphicObject() :
	meshId(0),
	color(glm::vec4(1.0f, 1.0f, 1.0f, 1.0f)),
	modelMatrix(glm::mat4(1.0f))
	{}

void GraphicObject::setColor(const vec4& color) {
	this->color = color;
}

void GraphicObject::setPosition(const vec3& position) {
	modelMatrix = translate(mat4(1.0f), position);
}

void GraphicObject::setAngle(float degree) {
	modelMatrix = rotate(modelMatrix, radians(degree), vec3(0.0f, 1.0f, 0.0f));
}

void GraphicObject::setMeshId(int id) {
	this->meshId = id;
}

vec4& GraphicObject::getColor() {
	return color;
}

mat4& GraphicObject::getModelMatrix() {
	return modelMatrix;
}

int GraphicObject::getMeshId() {
	return meshId;
}