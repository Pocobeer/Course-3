#include "Data.h"
#include "GraphicObject.h"
// ������������ ������������ ����
using namespace glm;
using namespace std;
// ������ ����������� ��������
vector<GraphicObject> graphicObjects;
// ������������ ������
// ������� ��� ������������� ���� ����� ������ (������, ������� � �.�.)
void initData()
{

	GraphicObject temp;
	for (int i = -40; i <= 40; i += 5) {
		for (int j = -40; j <= 40; j += 5) {
			temp.setPosition(vec3(i, 0, j));
			temp.setAngle(0);
			temp.set�olor(vec3(0.0, 0.0, 1.0));
			graphicObjects.push_back(temp);
		}
	}
	//GraphicObject tempGraphicObject1;
	//// 1 -----------------------------------------
	//tempGraphicObject1.setPosition(vec3(5, 0, 0));
	//tempGraphicObject1.setAngle(180);
	//tempGraphicObject1.set�olor(vec3(1, 0, 0));
	//graphicObjects.push_back(tempGraphicObject1);

	//GraphicObject tempGraphicObject2;
	////2-------------------------------------------
	//tempGraphicObject2.setPosition(vec3(-5, 0, 0));
	//tempGraphicObject2.setAngle(0);
	//tempGraphicObject2.set�olor(vec3(0, 0, 1));
	//graphicObjects.push_back(tempGraphicObject2);

	//GraphicObject tempGraphicObject3;
	////3-------------------------------------------
	//tempGraphicObject3.setPosition(vec3(0, 0, -5));
	//tempGraphicObject3.setAngle(270);
	//tempGraphicObject3.set�olor(vec3(0, 1, 0));
	//graphicObjects.push_back(tempGraphicObject3);

	//GraphicObject tempGraphicObject4;
	////4-------------------------------------------
	//tempGraphicObject4.setPosition(vec3(0, 0, 5));
	//tempGraphicObject4.setAngle(90);
	//tempGraphicObject4.set�olor(vec3(1, 1, 1));
	//graphicObjects.push_back(tempGraphicObject4);
}