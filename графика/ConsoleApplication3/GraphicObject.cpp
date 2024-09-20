#include "GraphicObject.h"
using namespace glm;
GraphicObject::GraphicObject()
{
	position = vec3(0.0f, 0.0f, 0.0f);
	angle = 0.0f;
	color = vec3(1.0f, 1.0f, 1.0f);
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
	glPushMatrix(); // ��������� ������� ��������� �������

	// ��������� ������� ������
	glMultMatrixf(value_ptr(modelMatrix));

	// ������������� ����
	glColor3f(color.r, color.g, color.b);

	// ������ ������
	glutWireTeapot(1.0); // ������� ������ � �������� 1.0

	glPopMatrix(); // ��������������� ��������� �������
}