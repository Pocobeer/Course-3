
#include "Camera.h"
// Конструкторы
Camera::Camera() : r(10.0f), angleX(0.0f), angleY(45.0f) {
    recalculatePosition();
}

Camera::Camera(vec3 position) {
    setPosition(position);
}

Camera::Camera(float x, float y, float z) {
    setPosition(vec3(x, y, z));
}

// Установка и получение позиции камеры
void Camera::setPosition(vec3 position) {
    this->position = position;
    r = length(position);
    vec3 v1 = position;
    vec3 v2 = vec3(v1.x, 0, v1.z);

    float cos_y = dot(normalize(v1), normalize(v2));
    angleY = degrees(acos(cos_y));

    float cos_x = dot(normalize(v2), vec3(1, 0, 0));
    angleX = degrees(acos(cos_x));

    recalculatePosition();
}

vec3 Camera::getPosition() {
    return position;
}

// Функции для перемещения камеры
void Camera::rotateLeftRight(float degree) {
    angleX += degree;
    recalculatePosition();
}

void Camera::rotateUpDown(float degree) {
    angleY += degree;
    if (angleY < 5.0f) angleY = 5.0f; // Ограничение вниз
    if (angleY > 85.0f) angleY = 85.0f; // Ограничение вверх
    recalculatePosition();
}

void Camera::zoomInOut(float distance) {
    r += distance;
    if (r < 1.0f) r = 1.0f; // Минимальное расстояние
    if (r > 100.0f) r = 100.0f; // Максимальное расстояние
    recalculatePosition();
}

// Функция для установки матрицы камеры
void Camera::apply() {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(position.x, position.y, position.z,
        10.0f, 0.0f, 10.0f, // Точка наблюдения
        0.0f, 1.0f, 0.0f); // Вектор "вверх"
}

// Перерасчет позиции камеры после поворотов
void Camera::recalculatePosition() {
    float radX = radians(angleX);
    float radY = radians(angleY);

    position.x = r * sin(radX) * cos(radY);
    position.y = r * sin(radY);
    position.z = r * cos(radX) * cos(radY);
}
