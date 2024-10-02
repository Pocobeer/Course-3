#include "Data.h"
#include "GraphicObject.h"
// используемые пространства имен
using namespace glm;
using namespace std;
// список графических объектов
vector<GraphicObject> graphicObjects;
// используемая камера
// функция для инициализации всех общих данных (камера, объекты и т.д.)
void initData()
{

	GraphicObject temp;
	for (int i = -40; i <= 40; i += 5) {
		for (int j = -40; j <= 40; j += 5) {
			temp.setPosition(vec3(i, 0, j));
			temp.setAngle(0);
			temp.setСolor(vec3(0.0, 0.0, 1.0));
			graphicObjects.push_back(temp);
		}
	}
	//GraphicObject tempGraphicObject1;
	//// 1 -----------------------------------------
	//tempGraphicObject1.setPosition(vec3(5, 0, 0));
	//tempGraphicObject1.setAngle(180);
	//tempGraphicObject1.setСolor(vec3(1, 0, 0));
	//graphicObjects.push_back(tempGraphicObject1);

	//GraphicObject tempGraphicObject2;
	////2-------------------------------------------
	//tempGraphicObject2.setPosition(vec3(-5, 0, 0));
	//tempGraphicObject2.setAngle(0);
	//tempGraphicObject2.setСolor(vec3(0, 0, 1));
	//graphicObjects.push_back(tempGraphicObject2);

	//GraphicObject tempGraphicObject3;
	////3-------------------------------------------
	//tempGraphicObject3.setPosition(vec3(0, 0, -5));
	//tempGraphicObject3.setAngle(270);
	//tempGraphicObject3.setСolor(vec3(0, 1, 0));
	//graphicObjects.push_back(tempGraphicObject3);

	//GraphicObject tempGraphicObject4;
	////4-------------------------------------------
	//tempGraphicObject4.setPosition(vec3(0, 0, 5));
	//tempGraphicObject4.setAngle(90);
	//tempGraphicObject4.setСolor(vec3(1, 1, 1));
	//graphicObjects.push_back(tempGraphicObject4);
}