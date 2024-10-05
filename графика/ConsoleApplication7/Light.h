#pragma once
#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "GL/freeglut.h"
using namespace glm;

class Light {
public:
    // ������������
    Light();
    Light(vec3 position);
    Light(float x, float y, float z);

    // ������� ��������� ���������� ��������� �����
    void setPosition(vec3 position);
    void setAmbient(vec4 color);
    void setDiffuse(vec4 color);
    void setSpecular(vec4 color);

    // ��������� ���� ���������� ��������� ����� � �������� �������
    void apply(GLenum LightNumber = GL_LIGHT0);

private:
    // ��������� ��������� �����
    vec4 position;   // ������� ��������� �����
    vec4 ambient;    // ������� ������������
    vec4 diffuse;    // ��������� ������������
    vec4 specular;   // ���������� ������������
};