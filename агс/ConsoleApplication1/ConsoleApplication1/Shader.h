#pragma once
#include <string>
#include <GL/freeglut.h>


using namespace std;

class Shader
{
public:
	// �������� ������� �� ������� ������
	bool load(string vertexShaderFilename, string fragmentShaderFilename);
	// ����� ������� � �������� ��������
	void activate();
	// ���������� �������
	static void deactivate();
private:
	// �������� ���������� ������� ���������� ����
	// � �������� ��������� ������ ������� �� ���������� �����
	GLuint createShaderObject(GLenum shaderType, string filename);
private:
	// ��������� ��������� (������)
	GLuint program;
};