#include "Camera.h"
#include <glm/gtc/type_ptr.hpp>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <windows.h>

using namespace glm;



Camera::Camera() : 
    position(vec3(5.0f, 5.0f, 5.0f)), // Начальная позиция камеры
    target(vec3(0.0f, 0.0f, 0.0f)),    // Точка, в которую смотрит камера
    up(vec3(0.0f, 1.0f, 0.0f)),        // Вектор "вверх"
    fovy(45.0f),                       // Угол обзора
    aspect(4.0f / 3.0f),               // Соотношение сторон
    zNear(0.1f),                       // Ближняя плоскость отсечения
    zFar(100.0f)                       // Дальняя плоскость отсечения
{
    // Инициализация матриц
    recalculateViewMatrix();
    setProjectionMatrix(fovy, aspect, zNear, zFar);
}


void Camera::rotate(float horizAngle, float vertAngle) {
    vec3 direction = target - position;
    vec3 right = normalize(glm::cross(direction, up));

    // Горизонтальное вращение
    mat4 horizontalRot = glm::rotate(mat4(1.0f), radians(-horizAngle), up);
    direction = vec3(horizontalRot * vec4(direction, 0.0f));

    // Вертикальное вращение
    mat4 verticalRot = glm::rotate(mat4(1.0f), radians(-vertAngle), right);
    direction = vec3(verticalRot * vec4(direction, 0.0f));

    // Ограничение вертикального угла
    float angle = degrees(acos(dot(normalize(direction), up)));
    if (angle < 95.0f || angle > 175.0f) {
        return;
    }

    // Обновление позиции камеры
    position = target - direction;
    recalculateViewMatrix();
}

void Camera::setProjectionMatrix(float fovy, float aspect, float zNear, float zFar) {
    projectionMatrix = perspective(radians(fovy), aspect, zNear, zFar);
}

mat4& Camera::getProjectionMatrix() {
    return projectionMatrix;
}

mat4& Camera::getViewMatrix() {
    return viewMatrix;
}

void Camera::zoom(float dR) {
    // Вычисляем направление камеры
    vec3 direction = normalize(target - position);

    // Изменяем позицию камеры
    position += direction * dR;

    recalculateViewMatrix();
}

void Camera::recalculateViewMatrix()
{
    viewMatrix = lookAt(position, target, up);
}

void Camera::moveOXZ(float dx, float dz)
{
    // Вычисляем вектор "вправо"
    vec3 right = normalize(cross(target - position, up));

    // Перемещаем камеру и точку наблюдения
    position += right * dx + normalize(cross(up, right)) * dz;
    target += right * dx + normalize(cross(up, right)) * dz;

    recalculateViewMatrix();
}