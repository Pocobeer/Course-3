#pragma once
#include <GL/glut.h>

// Функция для инициализации симуляции
void initSimulation();

// Функция симуляции
void simulation();

// Функция для получения времени симуляции
float getSimulationTime();

void processInput(float deltaTime);