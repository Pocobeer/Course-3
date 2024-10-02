#pragma once
#include <windows.h>
#include <vector>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include "GraphicObject.h"
#include "PhongMaterial.h"
#include "Mesh.h"
#include "Light.h"
#include "Camera.h"
// список графических объектов
extern std::vector<GraphicObject> graphicObjects;
extern bool meshLoaded; // ќбъ€вление переменной
extern shared_ptr<Mesh> mesh; // ќбъ€вление указател€ на Mesh
extern std::vector<Light> lights;
extern Camera camera;
// используема€ камера
// функци€ дл€ инициализации всех общих данных (камера, объекты и т.д.)
void initData();