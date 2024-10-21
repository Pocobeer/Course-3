#pragma once
#include <glm/vec2.hpp> // Не забудьте подключить библиотеку GLM
#include "GraphicObject.h" // Подключите ваш класс GraphicObject

using glm::ivec2; // Используемivec2 из GLM

class GameObject {
public:
    // Конструктор
    GameObject();

    // Установка графического объекта
    void setGraphicObject(const GraphicObject& graphicObject);

    // Установка логических координат (два перегруженных метода для удобства)
    void setPosition(int x, int y);
    void setPosition(ivec2 position);
    void setPosition(int x, float height, int z);
    // Получение текущих логических координат
    ivec2 getPosition();

    // Вывод игрового объекта на экран
    void draw();

private:
    // Логические координаты игрового объекта
    ivec2 position;
    float height;
    // Графический объект (для вывода на экран)
    GraphicObject graphicObject;
};
