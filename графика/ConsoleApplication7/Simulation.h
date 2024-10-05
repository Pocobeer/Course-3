#pragma once
#include <GL/glut.h>
#include <windows.h> // ƒл€ использовани€ GetAsyncKeyState, QueryPerformanceCounter и QueryPerformanceFrequency
#include <iostream>
#include "Camera.h"
// ‘ункци€ дл€ инициализации симул€ции
void initSimulation();

// ‘ункци€ симул€ции
void simulation();

// ‘ункци€ дл€ получени€ времени симул€ции
float getSimulationTime();

void keyboardFunc(float deltaTime);