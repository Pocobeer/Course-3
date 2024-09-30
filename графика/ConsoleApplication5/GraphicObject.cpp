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
void GraphicObject::setСolor(vec3 color)
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

// расчет матрицы modelMatrix на основе position и angle
void GraphicObject::recalculateModelMatrix()
{
	modelMatrix = mat4(1.0f);
	modelMatrix = translate(modelMatrix, position);
	modelMatrix = rotate(modelMatrix, radians(angle), vec3(0.0f, 1.0f, 0.0f));
}
// вывести объект
void GraphicObject::draw()
{
	if (material) {
		material->apply();
	}
	glPushMatrix(); // Сохраняем текущее состояние матрицы

	// Применяем матрицу модели
	glMultMatrixf(value_ptr(modelMatrix));

	// Устанавливаем цвет
	glColor3f(color.r, color.g, color.b);

	// Рисуем чайник
	glutSolidTeapot(1.0f); // Выводим чайник с размером 1.0

	glPopMatrix(); // Восстанавливаем состояние матрицы
}