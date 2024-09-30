#include "Data.h"
#include "GraphicObject.h"
// ������������ ������������ ����
using namespace glm;
using namespace std;
// ������ ����������� ��������
vector<GraphicObject> graphicObjects;
vector<Light> lights;
// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData()
{
    // ������������� ������ ��������� �����
    Light light1(vec3(0, 5, 0)); // ���� ������
    light1.setAmbient(vec4(0.1f, 0.1f, 0.1f, 1.0f));
    light1.setDiffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    light1.setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    lights.push_back(light1);

    // ������������� ����������
    auto material1 = make_shared<PhongMaterial>();
    material1->setAmbient(vec4(0.2f, 0.0f, 0.0f, 1.0f));
    material1->setDiffuse(vec4(1.0f, 0.0f, 0.0f, 1.0f));
    material1->setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material1->setShininess(32.0f);

    GraphicObject tempGraphicObject1;
    tempGraphicObject1.setPosition(vec3(5, 0, 0));
    tempGraphicObject1.setAngle(180);
    tempGraphicObject1.setMaterial(material1); // ������������� ��������
    graphicObjects.push_back(tempGraphicObject1);

    auto material2 = make_shared<PhongMaterial>();
    material2->setAmbient(vec4(0.0f, 0.0f, 0.2f, 1.0f));
    material2->setDiffuse(vec4(0.0f, 0.0f, 1.0f, 1.0f));
    material2->setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material2->setShininess(32.0f);

    GraphicObject tempGraphicObject2;
    tempGraphicObject2.setPosition(vec3(-5, 0, 0));
    tempGraphicObject2.setAngle(0);
    tempGraphicObject2.setMaterial(material2);
    graphicObjects.push_back(tempGraphicObject2);

    auto material3 = make_shared<PhongMaterial>();
    material3->setAmbient(vec4(0.0f, 0.2f, 0.0f, 1.0f));
    material3->setDiffuse(vec4(0.0f, 1.0f, 0.0f, 1.0f));
    material3->setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material3->setShininess(32.0f);

    GraphicObject tempGraphicObject3;
    tempGraphicObject3.setPosition(vec3(0, 0, -5));
    tempGraphicObject3.setAngle(270);
    tempGraphicObject3.setMaterial(material3);
    graphicObjects.push_back(tempGraphicObject3);

    auto material4 = make_shared<PhongMaterial>();
    material4->setAmbient(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material4->setDiffuse(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material4->setSpecular(vec4(1.0f, 1.0f, 1.0f, 1.0f));
    material4->setShininess(32.0f);

    GraphicObject tempGraphicObject4;
    tempGraphicObject4.setPosition(vec3(0, 0, 5));
    tempGraphicObject4.setAngle(90);
    tempGraphicObject4.setMaterial(material4);
    graphicObjects.push_back(tempGraphicObject4);
}