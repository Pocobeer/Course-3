#pragma once
#include <vector>
#include <string>
#include<memory>
#include "Mesh.h"
#include "PhongMaterial.h"
#include "GameObject.h"
// ����� ��� �������� ������� ��������
class GameObjectFactory
{
public:
	// ������������� �������:
	// �������� ����� � ��������� ���������� ���������
	bool init(std::string filename);
	// �������� ������ ������� ��������� ����
	std::shared_ptr<GameObject> create(GameObjectType type, int x, int y);
private:
	// ���� ��� ������� ���� �������
	std::vector<std::shared_ptr<Mesh>> meshes;
	// ��������� ��� ������� ���� �������
	std::vector<std::shared_ptr<PhongMaterial>> materials;
};