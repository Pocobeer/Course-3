#include <GL/glew.h>
#include "RenderManager.h"
#include <iostream>

void RenderManager::addShader(const Shader& shader) {
    shaders.push_back(shader);
}
\

// ������������� RenderManager
void RenderManager::init() {
    // �������� ��������
    Shader defaultShader;
    if (!defaultShader.load("SHADER/Example.vsh", "SHADER/Example.fsh")) {
        std::cerr << "Failed to load default shader!" << std::endl;
        return;
    }
    shaders.push_back(defaultShader);

    // ��������� ���������� ���������� OpenGL
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // ������ ���� ����
}

// ������ ������ ���������� �����
void RenderManager::start() {
    // ������� ������ ����������� ��������
    graphicObjects.clear();

    // ������� �������
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// ��������� ������������ ������
void RenderManager::setCamera(Camera* camera) {
    this->camera = camera;
}

// ���������� ������� � ������� ����������
void RenderManager::addToRenderQueue(GraphicObject& graphicObject) {
    graphicObjects.push_back(graphicObject);
}

// ���������� ������ �����
void RenderManager::finish() {
    // ������� �������
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // ������� ������ ����� ������
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // ��������� ����� �������
    glEnable(GL_DEPTH_TEST);

    // ��������, ����������� �� ������
    if (!camera) {
        std::cerr << "Camera is not set!" << std::endl;
        return;
    }

    // ��������, ��������� �� �������
    if (shaders.empty()) {
        std::cerr << "No shaders loaded!" << std::endl;
        return;
    }

    // ��������� �������
    shaders[0].activate();

    // ��������� ������ �������� � ����
    shaders[0].setUniform("projectionMatrix", camera->getProjectionMatrix());
    shaders[0].setUniform("viewMatrix", camera->getViewMatrix());
    auto& rm = ResourceManager::instance();

    // ��������� ���� ��������
    for (auto& graphicObject : graphicObjects) {
        // ��������� ������� ������
        mat4 modelViewMatrix = camera->getViewMatrix() * graphicObject.getModelMatrix();
        shaders[0].setUniform("modelViewMatrix", modelViewMatrix);

        // ��������� �����
        shaders[0].setUniform("color", graphicObject.getColor());

        // �������� ��������
        int textureId = graphicObject.getTextureId();
        Texture* texture = rm.getTexture(textureId);
        if (texture != nullptr) {
            texture->bind(GL_TEXTURE0);
            shaders[0].setUniform("texture_0", 0);
        }
        else {
            std::cerr << "Texture not found for object with textureId: " << textureId << std::endl;
        }

        // ��������� ����
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