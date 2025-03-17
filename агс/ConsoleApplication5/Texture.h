#pragma once
#include <GL/glew.h>
#include <string>
#include <IL/il.h>
//#include <IL/ilu.h>
//#include <IL/ilut.h>

using namespace std;

// ����� ��� ������ � ���������
class Texture
{
public:
	// �������� �������� �� �������� �����
	bool load(string filename);
	// ���������� �������� (�������� � ����������� �����)
	void bind(GLenum texUnit = GL_TEXTURE0);
private:
	// ������ ����������� �������
	GLuint texIndex;
};