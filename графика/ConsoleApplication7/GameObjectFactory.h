#pragma once
#ifdef GetObject
#undef GetObject
#endif
#include <string>
#include <memory>
#include <vector>
#include <unordered_map>
#include <rapidjson/document.h>
#include <rapidjson/error/en.h>
#include "Mesh.h"
#include "PhongMaterial.h"
#include "GameObject.h"

using namespace std;
using namespace rapidjson;
// ����������� ����� ������� ��������
enum class GameObjectType {
	LIGHT_OBJECT, // ������ ������� ������
	HEAVY_OBJECT, // ������� ������� ������
	BORDER_OBJECT, // ��������� ������� ������
	PLAYER, // ������� ������ ��� ������������� ������
	BOMB, // ������� ������ ��� ������������� �����
	MONSTER // ������� ������ ��� ������������� ��������
};

// ����� ��� �������� ������� ��������
class GameObjectFactory
{
public:
	// ������������� �������:
	// �������� ����� � ��������� ���������� ���������
	bool init(string filename);
	// �������� ������ ������� ��������� ����
	shared_ptr<GameObject> create(GameObjectType type, int x, int y);
private:
	// ���� ��� ������� ���� �������
	vector<shared_ptr<Mesh>> meshes;
	// ��������� ��� ������� ���� �������
	vector<shared_ptr<PhongMaterial>> materials;
	// �������� �������� ��������
	unordered_map<GameObjectType, int> objectTypeToIndex; // ��� �������� ������� � ��������
};