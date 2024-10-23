#include "GameObject.h"



// �����������
GameObject::GameObject() : position(0, 0), height(0.0f), sost(MoveDirection::STOP), progress(0.0f), speed(3.0f), moving(false) {}

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

void GameObject::move(MoveDirection direction, float speed) {
    sost = direction;
    this->speed = speed;
    moving = (direction != MoveDirection::STOP);
}

// ����������� � ����� �������
void GameObject::moveTo(int x, int y, float speed) {
    // ��������� ����� ������� � ��������
    position = ivec2(x, y);
    this->speed = speed;
    moving = true;
}

bool GameObject::isMoving() const {
    return moving;
}

void GameObject::simulate(float deltaTime) {
    if (moving) {
        progress += speed * deltaTime;

        if (progress >= 1.0f) {
            progress = 1.0f; // �������� ����� ������
            moving = false; // ��������� ��������

            // ��������� ������� � ����������� �� �����������
            switch (sost) {
            case MoveDirection::LEFT: position.x -= 1; break;
            case MoveDirection::RIGHT: position.x += 1; break;
            case MoveDirection::UP: position.y += 1; break;
            case MoveDirection::DOWN: position.y -= 1; break;
            default: break;
            }
            sost = MoveDirection::STOP; // ����� ���������
        }
    }
}


// ����� �������� ������� �� �����
void GameObject::draw(){
    graphicObject.setPosition(vec3(position.x, height, position.y));

    graphicObject.draw(); // ��������������, ��� ����� draw �� ��������� ����������
}
