#include "GameObject.h"

// Конструктор
GameObject::GameObject() : position(0, 0), height(0.0f) {}

// Установка графического объекта
void GameObject::setGraphicObject(const GraphicObject& graphicObject) {
    this->graphicObject = graphicObject; // Копирование графического объекта
}

// Установка логических координат
void GameObject::setPosition(int x, int y) {
    position = ivec2(x, y);
}

void GameObject::setPosition(ivec2 position) {
    this->position = position;
}

void GameObject::setPosition(int x, float height, int z) {
    position = ivec2(x, z); // Сохраняем X и Z как логические координаты
    this->height = height; // Сохраняем Y как высоту
}

// Получение текущих логических координат
ivec2 GameObject::getPosition(){
    return position;
}

// Вывод игрового объекта на экран
void GameObject::draw(){
    graphicObject.setPosition(vec3(position.x, height, position.y));

    graphicObject.draw(); // Предполагается, что метод draw не принимает аргументов
}
