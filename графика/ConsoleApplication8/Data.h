#pragma once
#include "GraphicObject.h"
#include <windows.h>
#include <vector>
#include "GL/freeglut.h"
#include <glm/glm.hpp>

#include "Light.h"
#include "Camera.h"
#include "GameObjectFactory.h"

// ������ ����������� ��������
extern vector<GraphicObject> graphicObjects;
extern bool meshLoaded; // ���������� ����������
extern shared_ptr<Mesh> mesh; // ���������� ��������� �� Mesh
extern vector<Light> lights;
extern Camera camera;
extern int passabilityMap[21][21];
extern shared_ptr<GameObject> mapObjects[21][21];
extern GameObjectFactory gameObjectFactory;
extern shared_ptr<GameObject> player;
extern GraphicObject planeGraphicObject;

// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData();
//void initializeMapObjects(int passabilityMap[21][21]);
void renderScene();