#pragma once
#include <vector>
#include <string>
#include<memory>
#include "Mesh.h"
#include "PhongMaterial.h"
#include "GameObject.h"
// КЛАСС ДЛЯ СОЗДАНИЯ ИГРОВЫХ ОБЪЕКТОВ
class GameObjectFactory
{
public:
	// инициализация фабрики:
	// загрузка мешей и установка параметров материала
	bool init(std::string filename);
	// создание нового объекта заданного типа
	std::shared_ptr<GameObject> create(GameObjectType type, int x, int y);
private:
	// меши для каждого типа объекта
	std::vector<std::shared_ptr<Mesh>> meshes;
	// материалы для каждого типа объекта
	std::vector<std::shared_ptr<PhongMaterial>> materials;
};