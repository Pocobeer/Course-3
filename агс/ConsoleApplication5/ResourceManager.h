#pragma once
#include <string>
#include <vector>
#include <map>
#include "Mesh.h"
#include "Texture.h"

using namespace std;

// КЛАСС ДЛЯ РАБОТЫ С МЕНЕДЖЕРОМ РЕСУРСОВ (РЕАЛИЗОВАН НА ОСНОВЕ ШАБЛОНА SINGLTON)
class ResourceManager
{
public:
	// Статик-метод для получения экземпляра менеджера ресурса.
	// Всегда будет возвращена ссылка на объект, хранящийся в единственном экземпляре.
	static ResourceManager& instance()
	{
		static ResourceManager ResourceManager;
		return ResourceManager;
	}
	// Загрузка одного меша из указанного obj-файла
	// Возвращаемое значение - индекс меша в менеджере ресурсов
	int loadMesh(const string& filename);
	// Получение меша по его индексу
	// Если такого меша нет (недействительный индекс) возвращается nullptr
	Mesh* getMesh(int index);
	// Загрузка одной текстуры из указанного файла
	int loadTexture(const string& filename);
	// Получение текстуры по её индексу
	Texture* getTexture(int index);
	void printDebugInfo() const;
private:
	// конструктор по умолчанию (объявлен приватным)
	// в результате нельзя создать ни одного объекта данного класса вне самого класса
	ResourceManager() {};
	// конструктора копирования нет (удален)
	ResourceManager(const ResourceManager& v) = delete;
	// оператора присваивания нет (удален)
	ResourceManager& operator=(const ResourceManager& v) = delete;
private:
	// вектор для хранения всех мешей
	vector<Mesh> meshes;
	// map для хранения соответствия между именем запрашиваемого файла
	// и индексом в контейнере meshes
	map <string, int> meshes_id;
	vector<Texture> textures;
	map<string, int> textures_id;
};