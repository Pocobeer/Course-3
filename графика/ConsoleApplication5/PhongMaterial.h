#include <string>
#include <glm/glm.hpp> // Для работы с векторами и цветами, если используете GLM
using namespace std;
using namespace glm;

class PhongMaterial
{
public:
    // Конструктор по умолчанию
    PhongMaterial();

    // Задание параметров материала
    void setAmbient(vec4 color);
    void setDiffuse(vec4 color);
    void setSpecular(vec4 color);
    void setEmission(vec4 color);
    void setShininess(float p);

    // Загрузка параметров материала из внешнего текстового файла
    void load(const string& filename);

    // Установка всех параметров материала
    void apply();

private:
    // Фоновая составляющая
    vec4 ambient;
    // Диффузная составляющая
    vec4 diffuse;
    // Зеркальная составляющая
    vec4 specular;
    // Самосвечение
    vec4 emission;
    // Степень отполированности
    float shininess;
};
