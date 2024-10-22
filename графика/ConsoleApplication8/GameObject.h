#pragma once
#include <glm/vec2.hpp> // Не забудьте подключить библиотеку GLM
#include "GraphicObject.h" // Подключите ваш класс GraphicObject

using glm::ivec2; // Используемivec2 из GLM

enum class MoveDirection { STOP, LEFT, RIGHT, UP, DOWN };

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

    // Установка состояния перемещения
    void move(MoveDirection direction, float speed = 3.0f);

    // Проверка на то, что объект в настоящий момент движется
    bool isMoving() const;

    // Симуляция игрового объекта (плавное перемещение объекта)
    void simulate(float deltaTime);

    // Вывод игрового объекта на экран
    void draw();

private:
    // Логические координаты игрового объекта
    ivec2 position;
    float height;
    // Графический объект (для вывода на экран)
    GraphicObject graphicObject;

    // Состояние объекта (направление движения)
    MoveDirection sost;

    // Прогресс в перемещении (от 0.0 до 1.0)
    float progress;

    // Скорость перемещения
    float speed;

    // Флаг, указывающий, что объект движется
    bool moving;
};
