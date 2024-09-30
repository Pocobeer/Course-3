#pragma once
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"
#include <cmath>

using namespace glm;

class Camera
{
public:
    // Конструкторы
    Camera();
    Camera(vec3 position);
    Camera(float x, float y, float z);

    // Установка и получение позиции камеры
    void setPosition(vec3 position);
    vec3 getPosition();

    // Функции для перемещения камеры
    void rotateLeftRight(float degree);
    void rotateUpDown(float degree);
    void zoomInOut(float distance);

    // Функция для установки матрицы камеры
    void apply();

private:
    // Перерасчет позиции камеры после поворотов
    void recalculatePosition();

private:
    // Радиус и углы поворота
    float r;       // Расстояние от камеры до точки наблюдения
    float angleX;  // Угол поворота влево/вправо
    float angleY;  // Угол возвышения
    // Позиция камеры
    vec3 position; // Текущая позиция камеры
};