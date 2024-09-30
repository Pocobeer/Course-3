#pragma once
#include <string>
#include <memory>
#include <glm/glm.hpp> // ��� ������ � ��������� � �������, ���� ����������� GLM
using namespace std;
using namespace glm;

class PhongMaterial
{
public:
    // ����������� �� ���������
    PhongMaterial();

    // ������� ���������� ���������
    void setAmbient(vec4 color);
    void setDiffuse(vec4 color);
    void setSpecular(vec4 color);
    void setEmission(vec4 color);
    void setShininess(float p);

    // �������� ���������� ��������� �� �������� ���������� �����
    void load(const string& filename);

    // ��������� ���� ���������� ���������
    void apply();
    string vec4_to_string(const glm::vec4& vec) {
        return "(" + std::to_string(vec.x) + ", " + std::to_string(vec.y) + ", "
            + std::to_string(vec.z) + ", " + std::to_string(vec.w) + ")";
    }

private:
    // ������� ������������
    vec4 ambient;
    // ��������� ������������
    vec4 diffuse;
    // ���������� ������������
    vec4 specular;
    // ������������
    vec4 emission;
    // ������� ����������������
    float shininess;
};
