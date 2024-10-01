#pragma once
#include <string>
#include <memory>
#include <Windows.h>

#include <GL/gl.h>
#include <GL/glut.h>
#include "GL/freeglut.h"
#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"

#include <fstream>
#include <sstream>
#include <iostream>
using namespace std;
using namespace glm;

class PhongMaterial
{
public:
    // ����������� �� ���������
    PhongMaterial();

    // ������� ���������� ���������
    void setAmbient(vec4 color);
    void setDiffuse(vec4 color);
    void setSpecular(vec4 color);
    void setEmission(vec4 color);
    void setShininess(float p);

    // �������� ���������� ��������� �� �������� ���������� �����
    void load(const string& filename);

    // ��������� ���� ���������� ���������
    void apply();
    string vec4_to_string(const glm::vec4& vec) {
        return "(" + std::to_string(vec.x) + ", " + std::to_string(vec.y) + ", "
            + std::to_string(vec.z) + ", " + std::to_string(vec.w) + ")";
    }

private:
    // ������� ������������
    vec4 ambient;
    // ��������� ������������
    vec4 diffuse;
    // ���������� ������������
    vec4 specular;
    // ������������
    vec4 emission;
    // ������� ����������������
    float shininess;
};
