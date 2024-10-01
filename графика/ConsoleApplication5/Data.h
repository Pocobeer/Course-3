#pragma once
#include <windows.h>
#include <vector>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include "Camera.h"
#include "GraphicObject.h"
#include "Light.h"
#include "PhongMaterial.h"
// ������ ����������� ��������
extern std::vector<GraphicObject> graphicObjects;
extern std::vector<Light> lights;
extern Camera camera;
// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData();