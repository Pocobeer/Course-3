#pragma once
#include <glm/gtc/type_ptr.hpp>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

// КЛАСС ДЛЯ РАБОТЫ С КАМЕРОЙ
class Camera
{
public:
	// конструктор по умолчанию
	Camera();
	// установить матрицу проекции
	void setProjectionMatrix(float fovy, float aspect, float zNear, float zFar);
	// получить матрицу проекции
	mat4& getProjectionMatrix();
	// получить матрицу вида
	mat4& getViewMatrix();
	// передвинуть камеру и точку наблюдения в горизонтальной плоскости (OXZ)
	void moveOXZ(float dx, float dz);
	// повернуть в горизонтальной и вертикальной плоскости (угол задается в градусах)
	void rotate(float horizAngle, float vertAngle);
	// приблизить/удалить камеру к/от точки наблюдения
	void zoom(float dR);
private:
	// пересчитать матрицу вида
	void recalculateViewMatrix();
private:
	mat4 viewMatrix; // Матрица вида
	mat4 projectionMatrix; // Матрица проекции
	vec3 position;
	vec3 target;
	vec3 up;
	vec3 right;
	vec3 worldUp;
	float fovy;  // Угол обзора (в градусах)
	float aspect; // Соотношение сторон (ширина / высота)
	float zNear; // Ближняя плоскость отсечения
	float zFar;  // Дальняя плоскость отсечения
};