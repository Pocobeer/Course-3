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