#pragma once
#include <windows.h>
#include <vector>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include "Camera.h"
#include "GraphicObject.h"
#include "Light.h"
#include "PhongMaterial.h"
// список графических объектов
extern std::vector<GraphicObject> graphicObjects;
extern std::vector<Light> lights;
extern Camera camera;
// используемая камера
// функция для инициализации всех общих данных (камера, объекты и т.д.)
void initData();