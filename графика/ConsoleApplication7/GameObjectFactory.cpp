#include "GameObjectFactory.h"
#include <fstream>
#include <iostream>
#include <rapidjson/filereadstream.h>
#include <rapidjson/error/en.h>

// ����� ������������� �������
bool GameObjectFactory::init(std::string filename) {
    // �������� �����
    FILE* fp = fopen(filename.c_str(), "r");
    if (!fp) {
        std::cerr << "�� ������� ������� ����: " << filename << std::endl;
        return false;
    }

    // ������ JSON-���������
    char readBuffer[65536];
    rapidjson::FileReadStream is(fp, readBuffer, sizeof(readBuffer));
    rapidjson::Document document;
    document.ParseStream(is);
    fclose(fp);

    // �������� �� ������� ������ � ���������
    if (document.HasParseError()) {
        std::cerr << "������ �������� JSON: " << rapidjson::GetParseError_En(document.GetParseError()) << std::endl;
        return false;
    }

    // �������� ����� � ���������� �� JSON
    if (document.IsObject()) {
        for (auto& obj : document.GetObject()) {
            GameObjectType type;
            std::string objectName = obj.name.GetString(); // �������� ��� �������

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
                continue; // ���������� ����������� ����
            }

            // �������� ����
           // ��������������, ��� obj.value - ��� ������ JSON, ���������� ���������� � ����
            if (obj.value.HasMember("mesh") && obj.value["mesh"].IsString()) {
                std::string meshFile = obj.value["mesh"].GetString(); // �������� ������ � ������ �����
                meshes[type] = std::make_shared<Mesh>(meshFile); // ������� shared_ptr ��� ����
            }
            else {
                // ��������� ������, ����� "mesh" ����������� ��� �� �������� �������
                std::cerr << "������: 'mesh' �� ������ ��� �� �������� ������� ��� ����: " << objectName << std::endl;
            }


            // �������� ���������
            // �������� ���������
            const rapidjson::Value& materialObj = obj.value["material"]; // ����������� const ������ �� ������ JSON
            auto material = std::make_shared<PhongMaterial>();

            // ��������������, ��� materialObj �������� ������� ��� ambient, diffuse � �.�.
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
// ����� �������� �������� �������
std::shared_ptr<GameObject> GameObjectFactory::create(GameObjectType type, int x, int y) {
    auto meshIt = meshes.find(type);
    auto materialIt = materials.find(type);

    if (meshIt != meshes.end() && materialIt != materials.end()) {
        auto gameObject = std::make_shared<GameObject>(meshIt->second, materialIt->second, x, y);
        return gameObject;
    }

    std::cerr << "�� ������� ������� ������: ����������� ��� ��� �������� ��� ����." << std::endl;
    return nullptr;
}
