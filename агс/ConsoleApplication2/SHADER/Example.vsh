#version 330 core

uniform vec2 offset;

in vec2 vPosition; // ����� �������� location
out vec2 fragPosition; // �������� ������� �� ����������� ������

void main()
{
    fragPosition = vPosition; // ��������� ������� ��� ������������ �������
    gl_Position = vec4(vPosition + offset, 0.0, 1.0); // ���������� ���������� �������
}