#pragma once
#include "GameObject.h"
#include "Data.h"
#include <GL/glut.h>
#include <windows.h> // ��� ������������� GetAsyncKeyState, QueryPerformanceCounter � QueryPerformanceFrequency
#include <iostream>
#include "Camera.h"

// ������� ��� ������������� ���������
void initSimulation();

// ������� ���������
void simulation();

bool checkCollision(const ivec2& newPosition);

// ������� ��� ��������� ������� ���������
float getSimulationTime();

void keyboardFunc(float deltaTime);