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

class Mesh {
public:
    Mesh();
    void load(const std::string& filename);
    void draw();

private:
    std::vector<Vertex> vertices; // ������ ������ ������������� �����
};
