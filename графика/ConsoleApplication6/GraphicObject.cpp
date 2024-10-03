#include "GraphicObject.h"
using namespace glm;
using namespace std;
GraphicObject::GraphicObject()
{
	position = vec3(0.0f, 0.0f, 0.0f);
	angle = 0.0f;
	color = vec3(0.0f, 0.0f, 0.0f);
	recalculateModelMatrix();
}
void GraphicObject::setPosition(vec3 position)
{
	this->position = position;
	recalculateModelMatrix();
}
vec3 GraphicObject::getPosition()
{
	return position;
}
void GraphicObject::setAngle(float grad)
{
	angle = grad;
	recalculateModelMatrix();
}
float GraphicObject::getAngle()
{
	return angle;
}
void GraphicObject::set�olor(vec3 color)
{
	this->color = color;
}
vec3 GraphicObject::getColor()
{
	return color;
}
void GraphicObject::setMaterial(shared_ptr<PhongMaterial> material) {
	this->material = material;
}

void GraphicObject::setMesh(shared_ptr<Mesh> mesh) {
	this->mesh = mesh;
}

// ������ ������� modelMatrix �� ������ position � angle
void GraphicObject::recalculateModelMatrix()
{
	modelMatrix = mat4(1.0f);
	modelMatrix = translate(modelMatrix, position);
	modelMatrix = rotate(modelMatrix, radians(angle), vec3(0.0f, 1.0f, 0.0f));
}
// ������� ������
void GraphicObject::draw()
{
	if (material) {
		material->apply();
	}

	if (mesh) {
		mesh->draw();
	}

	glPushMatrix(); // ��������� ������� ��������� �������
	modelMatrix = glm::translate(glm::mat4(1.0f), position);
	// ��������� ������� ������
	glMultMatrixf(value_ptr(modelMatrix));
	mesh->draw();
	glPopMatrix(); // ��������������� ��������� �������
	//cout << "Object drawn at position: " << position.x << ", " << position.y << ", " << position.z << endl;
}