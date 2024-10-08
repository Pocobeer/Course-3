#include "GameObjectFactory.h"
#include <fstream>
#include <iostream>
#include <rapidjson/filereadstream.h>
#include <rapidjson/error/en.h>

// Метод инициализации фабрики
bool GameObjectFactory::init(std::string filename) {
    // Открытие файла
    FILE* fp = fopen(filename.c_str(), "r");
    if (!fp) {
        std::cerr << "Не удалось открыть файл: " << filename << std::endl;
        return false;
    }

    // Чтение JSON-документа
    char readBuffer[65536];
    rapidjson::FileReadStream is(fp, readBuffer, sizeof(readBuffer));
    rapidjson::Document document;
    document.ParseStream(is);
    fclose(fp);

    // Проверка на наличие ошибок в документе
    if (document.HasParseError()) {
        std::cerr << "Ошибка парсинга JSON: " << rapidjson::GetParseError_En(document.GetParseError()) << std::endl;
        return false;
    }

    // Загрузка мешей и материалов из JSON
    if (document.IsObject()) {
        for (auto& obj : document.GetObject()) {
            GameObjectType type;
            std::string objectName = obj.name.GetString(); // Получаем имя объекта

            if (objectName == "PLAYER") {
                type = GameObjectType::PLAYER;
            }
            else if (objectName == "BOMB") {
                type = GameObjectType::BOMB;
            }
            else if (objectName == "MONSTER") {
                type = GameObjectType::MONSTER;
            }
            else if (objectName == "LIGHT_OBJECT") {
                type = GameObjectType::LIGHT_OBJECT;
            }
            else if (objectName == "HEAVY_OBJECT") {
                type = GameObjectType::HEAVY_OBJECT;
            }
            else if (objectName == "BORDER_OBJECT") {
                type = GameObjectType::BORDER_OBJECT;
            }
            else {
                continue; // Игнорируем неизвестные типы
            }

            // Загрузка меша
           // Предполагается, что obj.value - это объект JSON, содержащий информацию о меше
            if (obj.value.HasMember("mesh") && obj.value["mesh"].IsString()) {
                std::string meshFile = obj.value["mesh"].GetString(); // Получаем строку с именем файла
                meshes[type] = std::make_shared<Mesh>(meshFile); // Создаем shared_ptr для меша
            }
            else {
                // Обработка случая, когда "mesh" отсутствует или не является строкой
                std::cerr << "Ошибка: 'mesh' не найден или не является строкой для типа: " << objectName << std::endl;
            }


            // Загрузка материала
            // Загрузка материала
            const rapidjson::Value& materialObj = obj.value["material"]; // Используйте const ссылку на объект JSON
            auto material = std::make_shared<PhongMaterial>();

            // Предполагается, что materialObj содержит массивы для ambient, diffuse и т.д.
            material->ambient = {
                materialObj["ambient"][0].GetFloat(),
                materialObj["ambient"][1].GetFloat(),
                materialObj["ambient"][2].GetFloat(),
                materialObj["ambient"][3].GetFloat()
            };

            material->diffuse = {
                materialObj["diffuse"][0].GetFloat(),
                materialObj["diffuse"][1].GetFloat(),
                materialObj["diffuse"][2].GetFloat(),
                materialObj["diffuse"][3].GetFloat()
            };

            material->specular = {
                materialObj["specular"][0].GetFloat(),
                materialObj["specular"][1].GetFloat(),
                materialObj["specular"][2].GetFloat(),
                materialObj["specular"][3].GetFloat()
            };

            material->emission = {
                materialObj["emission"][0].GetFloat(),
                materialObj["emission"][1].GetFloat(),
                materialObj["emission"][2].GetFloat(),
                materialObj["emission"][3].GetFloat()
            };

            material->shininess = materialObj["shininess"].GetFloat();

            materials[type] = material;
        }
    }
}
// Метод создания игрового объекта
std::shared_ptr<GameObject> GameObjectFactory::create(GameObjectType type, int x, int y) {
    auto meshIt = meshes.find(type);
    auto materialIt = materials.find(type);

    if (meshIt != meshes.end() && materialIt != materials.end()) {
        auto gameObject = std::make_shared<GameObject>(meshIt->second, materialIt->second, x, y);
        return gameObject;
    }

    std::cerr << "Не удалось создать объект: отсутствуют меш или материал для типа." << std::endl;
    return nullptr;
}
