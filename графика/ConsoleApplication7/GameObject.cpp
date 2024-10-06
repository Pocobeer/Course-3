#include "GameObject.h"

// �����������
GameObject::GameObject() : position(0, 0), height(0.0f) {}

// ��������� ������������ �������
void GameObject::setGraphicObject(const GraphicObject& graphicObject) {
    this->graphicObject = graphicObject; // ����������� ������������ �������
}

// ��������� ���������� ���������
void GameObject::setPosition(int x, int y) {
    position = ivec2(x, y);
}

void GameObject::setPosition(ivec2 position) {
    this->position = position;
}

void GameObject::setPosition(int x, float height, int z) {
    position = ivec2(x, z); // ��������� X � Z ��� ���������� ����������
    this->height = height; // ��������� Y ��� ������
}

// ��������� ������� ���������� ���������
ivec2 GameObject::getPosition(){
    return position;
}

// ����� �������� ������� �� �����
void GameObject::draw(){
    graphicObject.setPosition(vec3(position.x, height, position.y));

    graphicObject.draw(); // ��������������, ��� ����� draw �� ��������� ����������
}
