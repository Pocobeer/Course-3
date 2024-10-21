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
// ОПРЕДЕЛЕНИЕ ТИПОВ ИГРОВЫХ ОБЪЕКТОВ
enum class GameObjectType {
	LIGHT_OBJECT, // легкий игровой объект
	HEAVY_OBJECT, // тяжелый игровой объект
	BORDER_OBJECT, // граничный игровой объект
	PLAYER, // игровой объект для представления игрока
	BOMB, // игровой объект для представления бомбы
	MONSTER // игровой объект для представления монстров
};

// КЛАСС ДЛЯ СОЗДАНИЯ ИГРОВЫХ ОБЪЕКТОВ
class GameObjectFactory
{
public:
	// инициализация фабрики:
	// загрузка мешей и установка параметров материала
	bool init(string filename);
	// создание нового объекта заданного типа
	shared_ptr<GameObject> create(GameObjectType type, int x, int y);
private:
	// меши для каждого типа объекта
	vector<shared_ptr<Mesh>> meshes;
	// материалы для каждого типа объекта
	vector<shared_ptr<PhongMaterial>> materials;
	// Хранение описаний объектов
	unordered_map<GameObjectType, int> objectTypeToIndex; // Для быстрого доступа к индексам
};