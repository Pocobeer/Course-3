#pragma once
#include <GL/glut.h>

// ������� ��� ������������� ���������
void initSimulation();

// ������� ���������
void simulation();

// ������� ��� ��������� ������� ���������
float getSimulationTime();

void keyboardFunc(float deltaTime);