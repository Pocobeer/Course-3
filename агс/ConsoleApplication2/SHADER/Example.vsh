#version 330 core

uniform vec2 offset;

in vec2 vPosition; // Явное указание location
out vec2 fragPosition; // Передаем позицию во фрагментный шейдер

void main()
{
    fragPosition = vPosition; // Сохраняем позицию для фрагментного шейдера
    gl_Position = vec4(vPosition + offset, 0.0, 1.0); // Корректное вычисление позиции
}