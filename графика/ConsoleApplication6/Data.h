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
// ������ ����������� ��������
extern std::vector<GraphicObject> graphicObjects;
extern bool meshLoaded; // ���������� ����������
extern shared_ptr<Mesh> mesh; // ���������� ��������� �� Mesh
extern std::vector<Light> lights;
extern Camera camera;
// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData();