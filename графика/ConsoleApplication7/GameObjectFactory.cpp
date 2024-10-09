#include "GameObjectFactory.h"
#include <iostream>
#include <fstream>

using namespace std;

bool GameObjectFactory::init(string filename) {
    // ��������� JSON-����
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "�� ������� ������� ����: " << filename << endl;
        return false;
    }

    // ������ ����������� �����
    string jsonContent((istreambuf_iterator<char>(file)), istreambuf_iterator<char>());
    Document document;
    document.Parse(jsonContent.c_str());

    if (document.HasParseError()) {
        cerr << "������ �������� JSON: " << GetParseError_En(document.GetParseError()) << endl;
        return false;
    }

    // ��������� ���� � ��������� �� JSON
    for (auto itr = document.MemberBegin(); itr != document.MemberEnd(); ++itr) {
        GameObjectType type;

        // ���������� ����� � ����
        string objectName = itr->name.GetString();
        if (objectName == "LightObject") type = GameObjectType::LIGHT_OBJECT;
        else if (objectName == "HeavyObject") type = GameObjectType::HEAVY_OBJECT;
        else if (objectName == "BorderObject") type = GameObjectType::BORDER_OBJECT;
        else if (objectName == "Player") type = GameObjectType::PLAYER;
        else if (objectName == "Bomb") type = GameObjectType::BOMB;
        else if (objectName == "Monster") type = GameObjectType::MONSTER;
        else continue; // ���������� ����������� ����

        // ��������� ������� � �������� �������� ����
        if (itr->value.HasMember("mesh") && itr->value["mesh"].IsString()) {
            string meshFile = itr->value["mesh"].GetString();
            shared_ptr<Mesh> mesh = make_shared<Mesh>();
            if (itr->value.HasMember("mesh") && itr->value["mesh"].IsString()) {
                string meshFile = itr->value["mesh"].GetString();
                shared_ptr<Mesh> mesh = make_shared<Mesh>();
                mesh->load(meshFile); // ������ �������� ����� load()

                // ���� ����� load() ����� ������� ������, �� ������ ���������� ��� ������ ������ load()
                meshes.push_back(mesh);
            }
            else {
                cerr << "�� ������� ��� ������� ������ ��� ���� ��� �������(1): " << objectName << endl;
                continue;
            }
        }
        else {
            cerr << "�� ������� ��� ������� ������ ��� ���� ��� �������(2): " << objectName << endl;
            continue;
        }

        // ��������� ������� � �������� �������� ���������
        if (itr->value.HasMember("material") && itr->value["material"].IsObject()) {
            const Value& materialValue = itr->value["material"];
            shared_ptr<PhongMaterial> material = make_shared<PhongMaterial>();

            if (materialValue.HasMember("ambient") && materialValue["ambient"].IsArray()) {
                material->setAmbient(vec4(materialValue["ambient"][0].GetFloat(),
                    materialValue["ambient"][1].GetFloat(),
                    materialValue["ambient"][2].GetFloat(),
                    materialValue["ambient"][3].GetFloat()));
            }

            if (materialValue.HasMember("diffuse") && materialValue["diffuse"].IsArray()) {
                material->setDiffuse(vec4(materialValue["diffuse"][0].GetFloat(),
                    materialValue["diffuse"][1].GetFloat(),
                    materialValue["diffuse"][2].GetFloat(),
                    materialValue["diffuse"][3].GetFloat()));
            }

            if (materialValue.HasMember("specular") && materialValue["specular"].IsArray()) {
                material->setSpecular(vec4(materialValue["specular"][0].GetFloat(),
                    materialValue["specular"][1].GetFloat(),
                    materialValue["specular"][2].GetFloat(),
                    materialValue["specular"][3].GetFloat()));
            }

            if (materialValue.HasMember("emission") && materialValue["emission"].IsArray()) {
                material->setEmission(vec4(materialValue["emission"][0].GetFloat(),
                    materialValue["emission"][1].GetFloat(),
                    materialValue["emission"][2].GetFloat(),
                    materialValue["emission"][3].GetFloat()));
            }

            if (materialValue.HasMember("shininess") && materialValue["shininess"].IsFloat()) {
                material->setShininess(materialValue["shininess"].GetFloat());
            }

            materials.push_back(material);
        }
        else {
            cerr << "�� ������ ��� ������� ����� �������� ��� �������: " << objectName << endl;
            continue;
        }

        // ��������� ������������ ���� ������� � �������
        objectTypeToIndex[type] = meshes.size() - 1; // ������ ���������� ������������ ����
    }


    return true;
}

shared_ptr<GameObject> GameObjectFactory::create(GameObjectType type, int x, int y) {
    if (objectTypeToIndex.find(type) == objectTypeToIndex.end()) {
        cerr << "����������� ��� �������� �������!" << endl;
        return nullptr;
    }

    auto gameObject = make_shared<GameObject>();
    GraphicObject graphicObject;
    graphicObject.setMesh(meshes[objectTypeToIndex[type]]);
    graphicObject.setMaterial(materials[objectTypeToIndex[type]]);

    gameObject->setGraphicObject(graphicObject);
    gameObject->setPosition(x, 0, y); // ��������� ������� (����� �������� �� �������������)

    return gameObject;
}
