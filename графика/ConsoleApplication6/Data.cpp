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
shared_ptr<GameObject> mapObjects[21][21];

int passabilityMap[21][21] = {
3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,2,0,0,0,3,
3,0,2,1,2,0,2,0,2,2,2,1,2,0,2,0,2,0,2,2,3,
3,0,2,0,2,0,0,0,2,0,2,0,0,0,2,0,1,0,0,0,3,
3,0,1,0,2,2,1,2,2,0,2,0,2,2,2,1,2,0,2,0,3,
3,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,2,0,2,0,3,
3,0,2,2,1,1,2,0,2,0,2,2,2,2,2,0,2,2,2,0,3,
3,0,2,0,0,0,2,0,2,0,0,0,0,0,2,0,0,0,0,0,3,
3,0,2,0,2,2,2,0,2,0,2,2,1,2,2,2,1,2,2,0,3,
3,0,0,0,2,0,0,0,2,0,2,0,0,0,0,0,0,0,1,0,3,
3,2,2,2,2,0,2,2,2,0,2,0,2,2,2,2,2,2,2,0,3,
3,0,0,0,2,0,0,0,1,0,2,0,0,0,2,0,0,0,0,0,3,
3,0,2,0,2,2,2,0,2,1,2,0,2,2,2,0,2,2,2,2,3,
3,0,2,0,0,0,2,0,0,0,2,0,0,0,2,0,2,0,0,0,3,
3,2,2,2,2,0,2,2,2,0,2,2,2,0,1,0,2,2,2,0,3,
3,0,0,0,0,0,2,0,2,0,0,0,2,0,1,0,0,0,2,0,3,
3,0,2,0,2,1,2,0,2,0,2,2,2,0,2,2,2,0,2,0,3,
3,0,1,0,1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,3,
3,0,2,1,2,0,2,2,2,2,2,0,2,0,2,0,2,2,2,2,3,
3,0,0,0,0,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,3,
3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
};

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
        material1->load("materials/material_4.txt");
        material2->load("materials/material_1.txt");
        material3->load("materials/material_3.txt");
        material4->load("materials/material_2.txt");
        //cout << "dwld" << endl;
    }
    catch (const exception& e) {
        cerr << e.what() << endl;
    }
    

    mesh = make_shared<Mesh>();
    auto mesh2 = make_shared<Mesh>();
    auto mesh3 = make_shared<Mesh>();
    auto mesh4 = make_shared<Mesh>();
    try {
        mesh->load("meshes/Box.obj");
        mesh2->load("meshes/SimplePlane.obj");
        mesh3->load("meshes/ChamferBox.obj");
        mesh4->load("meshes/Box.obj");
        cout << "dwldobj" << endl;
        meshLoaded = true;
    }
    catch (const exception& e) {
        cerr << e.what() << endl;
        meshLoaded = false;
    }
    GraphicObject floor;
    floor.setMesh(mesh2); // Убедитесь, что у вас есть метод setMesh в GraphicObject
    floor.setMaterial(material2);
    floor.setPosition(vec3(0.0f, -10.0f, 0.0f)); // Установка позиции
    graphicObjects.push_back(floor);// Добавление объекта в вектор


    GraphicObject obj1;
    obj1.setMesh(mesh); // Убедитесь, что у вас есть метод setMesh в GraphicObject
    obj1.setMaterial(material1);
    obj1.setPosition(vec3(0.0f, 0.0f, 0.0f)); // Установка позиции
    graphicObjects.push_back(obj1);// Добавление объекта в вектор

    GraphicObject obj2;
    obj2.setMesh(mesh4); // Убедитесь, что у вас есть метод setMesh в GraphicObject
    obj2.setMaterial(material3);
    obj2.setPosition(vec3(0.0f, 0.0f, 0.0f)); // Установка позиции
    graphicObjects.push_back(obj2);// Добавление объекта в вектор

    GraphicObject obj3;
    obj3.setMesh(mesh3); // Убедитесь, что у вас есть метод setMesh в GraphicObject
    obj3.setMaterial(material4);
    obj3.setPosition(vec3(0.0f, 0.0f, 0.0f)); // Установка позиции
    graphicObjects.push_back(obj3);// Добавление объекта в вектор

}
void initializeMapObjects(int passabilityMap[21][21]) {
    for (int i = 0; i < 21; ++i) {
        for (int j = 0; j < 21; ++j) {
            if (passabilityMap[i][j] == 0) { // Пол
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[0]); // Предполагаем, что graphicObjects[0] это пол
                //gameObject->setPosition(i-10, -5.5f,j-10); // Установка логических координат
                mapObjects[i][j] = gameObject; // Сохраняем объект в массиве
            }
            else if (passabilityMap[i][j] == 1) { // Проходимый объект типа 1
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[3]); // Заменить на подходящий объект
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
            }
            else if (passabilityMap[i][j] == 2) { // Проходимый объект типа 2
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[2]); // Заменить на подходящий объект
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
            }
            else if (passabilityMap[i][j] == 3) { // Проходимый объект типа 3
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[1]); // Заменить на подходящий объект
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
            }
            else {
                mapObjects[i][j] = nullptr; // Непроходимая ячейка или пустое пространство
            }
            //cout << "Создан объект в ячейке (" << i << ", " << j << ") с типом: " << passabilityMap[i][j] << endl;
        }
    }
}


void renderScene() {
    // Отрисовка объектов на карте
    for (int i = 0; i < 21; ++i) {
        for (int j = 0; j < 21; ++j) {
            if (mapObjects[i][j]) {
                mapObjects[i][j]->draw(); 
            }
        }
    }
}