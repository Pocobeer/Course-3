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
#include "GameObject.h"

// список графических объектов
extern vector<GraphicObject> graphicObjects;
extern bool meshLoaded; // ќбъ€вление переменной
extern shared_ptr<Mesh> mesh; // ќбъ€вление указател€ на Mesh
extern vector<Light> lights;
extern Camera camera;
extern int passabilityMap[21][21];
extern shared_ptr<GameObject> mapObjects[21][21];

// используема€ камера
// функци€ дл€ инициализации всех общих данных (камера, объекты и т.д.)
void initData();
void initializeMapObjects(int passabilityMap[21][21]);
void renderScene();