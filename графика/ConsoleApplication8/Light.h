#pragma once
#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "GL/freeglut.h"
using namespace glm;

class Light {
public:
    // Конструкторы
    Light();
    Light(vec3 position);
    Light(float x, float y, float z);

    // Задание различных параметров источника света
    void setPosition(vec3 position);
    void setAmbient(vec4 color);
    void setDiffuse(vec4 color);
    void setSpecular(vec4 color);

    // Установка всех параметров источника света с заданным номером
    void apply(GLenum LightNumber = GL_LIGHT0);

private:
    // Параметры источника света
    vec4 position;   // Позиция источника света
    vec4 ambient;    // Фоновая составляющая
    vec4 diffuse;    // Диффузная составляющая
    vec4 specular;   // Зеркальная составляющая
};