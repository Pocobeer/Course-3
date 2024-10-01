#pragma once
#include <GL/glut.h>
#include <windows.h> // ��� ������������� GetAsyncKeyState, QueryPerformanceCounter � QueryPerformanceFrequency
#include <iostream>
#include "Camera.h"
// ������� ��� ������������� ���������
void initSimulation();

// ������� ���������
void simulation();

// ������� ��� ��������� ������� ���������
float getSimulationTime();

void keyboardFunc(float deltaTime);