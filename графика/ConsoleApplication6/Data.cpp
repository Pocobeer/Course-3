#include "Data.h"
// используемые пространства имен
using namespace glm;
using namespace std;
// список графических объектов
vector<GraphicObject> graphicObjects;
bool meshLoaded = false; // Изначально меш не загружен
shared_ptr<Mesh> mesh = nullptr; // Указатель на Mesh
vector<Light> lights;
Camera camera;  // Объявляем камеру как глобальную переменную

void initData()
{
    // Инициализация одного источника света
    Light light1 = vec3(0.0f, 10.0f, 0.0f); // Свет сверху
    light1.setAmbient(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    light1.setDiffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    light1.setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    lights.push_back(light1);

    auto material1 = make_shared<PhongMaterial>();
    auto material2 = make_shared<PhongMaterial>();
    auto material3 = make_shared<PhongMaterial>();
    auto material4 = make_shared<PhongMaterial>();
    try {
        material1->load("materials/material_1.txt");
        material2->load("materials/material_2.txt");
        material3->load("materials/material_3.txt");
        material4->load("materials/material_4.txt");
        cout << "dwld" << endl;
    }
    catch (const exception& e) {
        cerr << e.what() << endl;
    }
    

    mesh = make_shared<Mesh>();
    try {
        mesh->load("meshes/Box.obj");
        cout << "dwldobj" << endl;
        meshLoaded = true;
    }
    catch (const exception& e) {
        cerr << e.what() << endl;
        meshLoaded = false;
    }

    GraphicObject obj;
    obj.setMesh(mesh); // Убедитесь, что у вас есть метод setMesh в GraphicObject
    obj.setMaterial(material1);
    obj.setPosition(glm::vec3(0.0f, 0.0f, 0.0f)); // Установка позиции

    // Добавление объекта в вектор
    graphicObjects.push_back(obj);
}