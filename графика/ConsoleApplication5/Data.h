#pragma once
#include <windows.h>
#include <vector>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include "Camera.h"
#include "GraphicObject.h"
// ������ ����������� ��������
extern std::vector<GraphicObject> graphicObjects;
// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData();