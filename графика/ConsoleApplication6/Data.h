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

// ������ ����������� ��������
extern vector<GraphicObject> graphicObjects;
extern bool meshLoaded; // ���������� ����������
extern shared_ptr<Mesh> mesh; // ���������� ��������� �� Mesh
extern vector<Light> lights;
extern Camera camera;
extern int passabilityMap[21][21];
extern shared_ptr<GameObject> mapObjects[21][21];

// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData();
void initializeMapObjects(int passabilityMap[21][21]);
void renderScene();