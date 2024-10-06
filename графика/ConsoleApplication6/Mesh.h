#pragma once

#include <windows.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <memory>
#include "Vertex.h"
#include <algorithm>
#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"

class Mesh {
public:
    Mesh();
    void load(const std::string& filename);
    void draw();

private:
    std::vector<Vertex> vertices; // Массив вершин полигональной сетки
    std::vector<Gluint> indices;//массив индексов
};
