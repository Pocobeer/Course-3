#pragma once
#include "Mesh.h"
#include <windows.h>
#include <stdio.h>
#include <iostream>
#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <memory>
#include "PhongMaterial.h"

using namespace glm;
// ����� ��� ������������� ������ ������������ �������
class GraphicObject
{
public:
	// �����������
	GraphicObject();
	// ��������� � ��������� ������� �������
	void setPosition(vec3 position);
	vec3 getPosition();
	// ��������� � ��������� ���� �������� � ��������
	// ������� �������������� � �������������� ���������
	// ������ ��� Oy �� ������� �������
	void setAngle(float grad);
	float getAngle();
	// ��������� �������� ����� �������
	void set�olor(vec3 color);
	vec3 getColor();
	// ��������� ������������� ���������
	void setMaterial(shared_ptr<PhongMaterial> material);
	// ��������� ������������� ����
	void setMesh(shared_ptr<Mesh> mesh);
	// ������� ������
	void draw();
private:
	// ������� ������� � ���������� ������� ���������
	vec3 position;
	// ���� �������� � �������������� ��������� (� ��������)
	float angle;
	// ���� ������
	vec3 color;
	// ������� ������ - ���� �� ��������� ������ ���
	mat4 modelMatrix;
	// ������������ ��������
	shared_ptr<PhongMaterial> material;
	// ������������ ���
	shared_ptr<Mesh> mesh;
	// ������ ������� modelMatrix �� ������ position � angle
	void recalculateModelMatrix();
};