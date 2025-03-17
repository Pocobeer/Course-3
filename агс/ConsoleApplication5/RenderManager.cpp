#include <GL/glew.h>
#include "RenderManager.h"
#include <iostream>

void RenderManager::addShader(const Shader& shader) {
    shaders.push_back(shader);
}
\

// Инициализация RenderManager
void RenderManager::init() {
    // Загрузка шейдеров
    Shader defaultShader;
    if (!defaultShader.load("SHADER/Example.vsh", "SHADER/Example.fsh")) {
        std::cerr << "Failed to load default shader!" << std::endl;
        return;
    }
    shaders.push_back(defaultShader);

    // Установка неизменных параметров OpenGL
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // Черный цвет фона
}

// Начало вывода очередного кадра
void RenderManager::start() {
    // Очистка списка графических объектов
    graphicObjects.clear();

    // Очистка буферов
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// Установка используемой камеры
void RenderManager::setCamera(Camera* camera) {
    this->camera = camera;
}

// Добавление объекта в очередь рендеринга
void RenderManager::addToRenderQueue(GraphicObject& graphicObject) {
    graphicObjects.push_back(graphicObject);
}

// Завершение вывода кадра
void RenderManager::finish() {
    // Очистка буферов
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // Очистка экрана белым цветом
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Включение теста глубины
    glEnable(GL_DEPTH_TEST);

    // Проверка, установлена ли камера
    if (!camera) {
        std::cerr << "Camera is not set!" << std::endl;
        return;
    }

    // Проверка, загружены ли шейдеры
    if (shaders.empty()) {
        std::cerr << "No shaders loaded!" << std::endl;
        return;
    }

    // Активация шейдера
    shaders[0].activate();

    // Установка матриц проекции и вида
    shaders[0].setUniform("projectionMatrix", camera->getProjectionMatrix());
    shaders[0].setUniform("viewMatrix", camera->getViewMatrix());
    auto& rm = ResourceManager::instance();

    // Рендеринг всех объектов
    for (auto& graphicObject : graphicObjects) {
        // Установка матрицы модели
        mat4 modelViewMatrix = camera->getViewMatrix() * graphicObject.getModelMatrix();
        shaders[0].setUniform("modelViewMatrix", modelViewMatrix);

        // Установка цвета
        shaders[0].setUniform("color", graphicObject.getColor());

        // Привязка текстуры
        int textureId = graphicObject.getTextureId();
        Texture* texture = rm.getTexture(textureId);
        if (texture != nullptr) {
            texture->bind(GL_TEXTURE0);
            shaders[0].setUniform("texture_0", 0);
        }
        else {
            std::cerr << "Texture not found for object with textureId: " << textureId << std::endl;
        }

        // Отрисовка меша
        int meshId = graphicObject.getMeshId();
        Mesh* mesh = rm.getMesh(meshId);
        if (mesh != nullptr) {
            mesh->drawOne();
        }
        else {
            std::cerr << "Mesh not found for object with meshId: " << meshId << std::endl;
        }
    }
    auto err = glGetError();
    if (err != GL_NO_ERROR) {
        cerr << "ERR: " << glewGetErrorString(err) << " \n";
    }

}