#pragma once
#include <string>
#include <vector>
#include <map>
#include "Mesh.h"

using namespace std;

// ����� ��� ������ � ���������� �������� (���������� �� ������ ������� SINGLTON)
class ResourceManager
{
public:
	// ������-����� ��� ��������� ���������� ��������� �������.
	// ������ ����� ���������� ������ �� ������, ���������� � ������������ ����������.
	static ResourceManager& instance()
	{
		static ResourceManager ResourceManager;
		return ResourceManager;
	}
	// �������� ������ ���� �� ���������� obj-�����
	// ������������ �������� - ������ ���� � ��������� ��������
	int loadMesh(const string& filename);
	// ��������� ���� �� ��� �������
	// ���� ������ ���� ��� (���������������� ������) ������������ nullptr
	Mesh* getMesh(int index);

	void printDebugInfo() const;
private:
	// ����������� �� ��������� (�������� ���������)
	// � ���������� ������ ������� �� ������ ������� ������� ������ ��� ������ ������
	ResourceManager() {};
	// ������������ ����������� ��� (������)
	ResourceManager(const ResourceManager& v) = delete;
	// ��������� ������������ ��� (������)
	ResourceManager& operator=(const ResourceManager& v) = delete;
private:
	// ������ ��� �������� ���� �����
	vector<Mesh> meshes;
	// map ��� �������� ������������ ����� ������ �������������� �����
	// � �������� � ���������� meshes
	map <string, int> meshes_id;
};