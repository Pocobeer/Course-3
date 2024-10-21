#pragma once

#include <windows.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <string>
#include <memory>
#include "Vertex.h"
#include <algorithm>
#include <GL/GL.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include "GL/freeglut.h"

using namespace glm;

class Mesh {
public:
    Mesh();
    void load(const std::string& filename);
    void draw();

private:
    std::vector<Vertex> vertices; // Массив вершин полигональной сетки

    std::vector<GLuint> indices;//массив индексов
};
