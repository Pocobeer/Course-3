#pragma once
#include <vector>
#include "Shader.h"
#include "Camera.h"
#include "GraphicObject.h"
#include "Mesh.h"
#include "ResourceManager.h"

// ����� ��� �������������� � OPENGL
// ���� ����� �������������� ����� ������������ ��������� ������� ������
class RenderManager
{
public:
	// ������-����� ��� ��������� ���������� ��������� �������.
	static RenderManager& instance()
	{
		static RenderManager renderManager;
		return renderManager;
	}
	void addShader(const Shader& shader);
	// ������������� ������� RenderManager, ����������� ����� ������������� OpenGL:
	// �������� ��������, ��������� ���������� ���������� � ������ �������������
	void init();
	// ������ ������ ���������� ����� (����������, ������� ������� ����������� ��������)
	void start();
	// ��������� ������������ ������
	void setCamera(Camera* camera);
	// ���������� � ������� ���������� ���������� ������� ��� ������
	void addToRenderQueue(GraphicObject& graphicObject);
	// ���������� ������ ����� (�������� ������)
	void finish();
private:
	// ����������� �� ��������� (���������)
	RenderManager() {};
	// ������������ ����������� ���
	RenderManager(const RenderManager& root) = delete;
	// ��������� ������������ ���
	RenderManager& operator=(const RenderManager&) = delete;
private:
	// ������������ �������
	std::vector<Shader> shaders;
	// ��������� �� ������
	Camera* camera;
	// ������ ����������� ��������, ������� ���������� ������� � ������ �����
	std::vector<GraphicObject> graphicObjects;
};