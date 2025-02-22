#pragma once
#include <glm/gtc/type_ptr.hpp>

using namespace glm;

// ����� ��� ������ � �������
class Camera
{
public:
	// ����������� �� ���������
	Camera();
	// ���������� ������� ��������
	void setProjectionMatrix(float fovy, float aspect, float zNear, float zFar);
	// �������� ������� ��������
	mat4& getProjectionMatrix();
	// �������� ������� ����
	mat4& getViewMatrix();
	// ����������� ������ � ����� ���������� � �������������� ��������� (OXZ)
	void moveOXZ(float dx, float dz);
	// ��������� � �������������� � ������������ ��������� (���� �������� � ��������)
	void rotate(float horizAngle, float vertAngle);
	// ����������/������� ������ �/�� ����� ����������
	void zoom(float dR);
private:
	// ����������� ������� ����
	void recalculateViewMatrix();
private:
	// ����������� ��������� ���� ������
	// ...
};