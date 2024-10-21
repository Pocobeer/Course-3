#pragma once
#include <GL/glut.h> 
 
#include "Camera.h"
#include "Data.h"
//#include "Light.h"
#include <windows.h>
#include <iostream>
#include <vector>

// Функции для обработки отображения и изменения размера окна
void reshape(int w, int h);
void display(void);