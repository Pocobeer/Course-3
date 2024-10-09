#include "Data.h"
// ������������ ������������ ����
using namespace glm;
using namespace std;
// ������ ����������� ��������
vector<GraphicObject> graphicObjects;
bool meshLoaded = false; // ���������� ��� �� ��������
shared_ptr<Mesh> mesh = nullptr; // ��������� �� Mesh
vector<Light> lights;
Camera camera;  // ��������� ������ ��� ���������� ����������
shared_ptr<GameObject> mapObjects[21][21];
GameObjectFactory gameObjectFactory;
shared_ptr<GameObject> player;
GraphicObject planeGraphicObject;

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

/*void initData()
{
    // ������������� ������ ��������� �����
    Light light1 = vec3(0.0f, 10.0f, 0.0f); // ���� ������
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
    floor.setMesh(mesh2); // ���������, ��� � ��� ���� ����� setMesh � GraphicObject
    floor.setMaterial(material2);
    floor.setPosition(vec3(0.0f, -10.0f, 0.0f)); // ��������� �������
    graphicObjects.push_back(floor);// ���������� ������� � ������


    GraphicObject obj1;
    obj1.setMesh(mesh); // ���������, ��� � ��� ���� ����� setMesh � GraphicObject
    obj1.setMaterial(material1);
    obj1.setPosition(vec3(0.0f, 0.0f, 0.0f)); // ��������� �������
    graphicObjects.push_back(obj1);// ���������� ������� � ������

    GraphicObject obj2;
    obj2.setMesh(mesh4); // ���������, ��� � ��� ���� ����� setMesh � GraphicObject
    obj2.setMaterial(material3);
    obj2.setPosition(vec3(0.0f, 0.0f, 0.0f)); // ��������� �������
    graphicObjects.push_back(obj2);// ���������� ������� � ������

    GraphicObject obj3;
    obj3.setMesh(mesh3); // ���������, ��� � ��� ���� ����� setMesh � GraphicObject
    obj3.setMaterial(material4);
    obj3.setPosition(vec3(0.0f, 0.0f, 0.0f)); // ��������� �������
    graphicObjects.push_back(obj3);// ���������� ������� � ������

}
void initializeMapObjects(int passabilityMap[21][21]) {
    for (int i = 0; i < 21; ++i) {
        for (int j = 0; j < 21; ++j) {
            if (passabilityMap[i][j] == 0) { // ���
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[0]); // ������������, ��� graphicObjects[0] ��� ���
                //gameObject->setPosition(i-10, -1.0f,j-10); // ��������� ���������� ���������
                mapObjects[i][j] = gameObject; // ��������� ������ � �������
            }
            else if (passabilityMap[i][j] == 1) { // ���������� ������ ���� 1
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[3]); // �������� �� ���������� ������
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
                //cout << "created at:" << i << ", " << j << endl;
            }
            else if (passabilityMap[i][j] == 2) { // ���������� ������ ���� 2
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[2]); // �������� �� ���������� ������
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
            }
            else if (passabilityMap[i][j] == 3) { // ���������� ������ ���� 3
                auto gameObject = make_shared<GameObject>();
                gameObject->setGraphicObject(graphicObjects[1]); // �������� �� ���������� ������
                gameObject->setPosition(i - 10, 0.5f, j - 10);
                mapObjects[i][j] = gameObject;
            }
            else {
                mapObjects[i][j] = nullptr; // ������������ ������ ��� ������ ������������
            }
            //cout << "������ ������ � ������ (" << i << ", " << j << ") � �����: " << passabilityMap[i][j] << endl;
        }
    }
}*/

void initData()
{
    // ������������� ������ ��������� �����
    Light light1 = vec3(0.0f, 10.0f, 0.0f); // ���� ������
    light1.setAmbient(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    light1.setDiffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    light1.setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    lights.push_back(light1);
    // ������������� ������� (� ���������� �� ������ json-�����)
    gameObjectFactory.init("GameObjectsDescription.json");
    // ������������� �������� �����
    for (int i = 0; i < 21; i++) {
        for (int j = 0; j < 21; j++) {
            switch (passabilityMap[i][j]) {
            case 1:
                mapObjects[i][j] = gameObjectFactory.create(GameObjectType::LIGHT_OBJECT, i-10, j-10);
                break;
            case 2:
                mapObjects[i][j] = gameObjectFactory.create(GameObjectType::HEAVY_OBJECT, i-10, j-10);
                break;
            case 3:
                mapObjects[i][j] = gameObjectFactory.create(GameObjectType::BORDER_OBJECT, i-10, j-10);
                break;
            default:
                mapObjects[i][j] = nullptr;
                break;
            }
        }
    }
    // ������������� �������� �����
    player = gameObjectFactory.create(GameObjectType::PLAYER, 19-10, 1-10);
    
    // ������������� ���������
    planeGraphicObject.setPosition(vec3(0, -0.5, 0));
    shared_ptr<Mesh> planeMesh = make_shared<Mesh>();
    planeMesh->load("meshes/HighPolyPlane.obj");

    planeGraphicObject.setMesh(planeMesh);
    shared_ptr<PhongMaterial> planeMaterial = make_shared<PhongMaterial>();
    planeMaterial->load("materials/PlaneMaterial.txt");
    planeGraphicObject.setMaterial(planeMaterial);
}


void renderScene() {
    graphicObjects.clear();
    // ��������� �������� �� �����
    for (int i = 0; i < 21; ++i) {
        for (int j = 0; j < 21; ++j) {
            if (mapObjects[i][j]) {
                mapObjects[i][j]->draw(); 
            }
        }
    }
    player->draw();
    planeGraphicObject.draw();
}