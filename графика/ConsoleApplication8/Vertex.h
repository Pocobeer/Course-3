#pragma once
#include <glm/glm.hpp>
using namespace glm;

struct Vertex {
    vec3 position;   // Геометрические координаты
    vec3 normal;     // Нормали
    vec2 texCoord;   // Текстурные координаты
};