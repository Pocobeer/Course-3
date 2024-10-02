#include "GameObject.h"

// Конструктор
GameObject::GameObject() : position(0, 0) {}

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

// Получение текущих логических координат
ivec2 GameObject::getPosition(){
    return position;
}

// Вывод игрового объекта на экран
void GameObject::draw(){
    graphicObject.draw(); // Предполагается, что метод draw не принимает аргументов
}
