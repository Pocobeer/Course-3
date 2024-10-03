#pragma once
#include <glm/vec2.hpp> // �� �������� ���������� ���������� GLM
#include "GraphicObject.h" // ���������� ��� ����� GraphicObject

using glm::ivec2; // ����������ivec2 �� GLM

class GameObject {
public:
    // �����������
    GameObject();

    // ��������� ������������ �������
    void setGraphicObject(const GraphicObject& graphicObject);

    // ��������� ���������� ��������� (��� ������������� ������ ��� ��������)
    void setPosition(int x, int y);
    void setPosition(ivec2 position);
    void setPosition(int x, float height, int z);
    // ��������� ������� ���������� ���������
    ivec2 getPosition();

    // ����� �������� ������� �� �����
    void draw();

private:
    // ���������� ���������� �������� �������
    ivec2 position;
    float height;
    // ����������� ������ (��� ������ �� �����)
    GraphicObject graphicObject;
};
