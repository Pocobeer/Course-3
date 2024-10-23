#pragma once
#include <glm/vec2.hpp> 
#include "GraphicObject.h" 

using glm::ivec2; // ����������ivec2 �� GLM

enum class MoveDirection { STOP, LEFT, RIGHT, UP, DOWN };

extern int passabilityMap[21][21];

class GameObject {
public:
    // �����������
    GameObject();

    // ��������� ������������ �������
    void setGraphicObject(const GraphicObject& graphicObject);

    
    void setPosition(int x, int y);
    void setPosition(ivec2 position);
    void setPosition(int x, float height, int z);
    // ��������� ������� ���������� ���������
    ivec2 getPosition();

    // ��������� ��������� �����������
    void move(MoveDirection direction, float speed);

    // ����������� � ����� �������
    void moveTo(int x, int y, float speed, char dir);

    // �������� �� ��, ��� ������ � ��������� ������ ��������
    bool isMoving() const;

    // ��������� �������� ������� (������� ����������� �������)
    void simulate(float deltaTime);

    // ����� �������� ������� �� �����
    void draw();

private:
    // ���������� ���������� �������� �������
    ivec2 position;
    float height;
    // ����������� ������ (��� ������ �� �����)
    GraphicObject graphicObject;

    // ��������� ������� (����������� ��������)
    MoveDirection sost;

    // �������� � ����������� (�� 0.0 �� 1.0)
    float progress;

    // �������� �����������
    float speed;

    // ����, �����������, ��� ������ ��������
    bool moving;
};
