#include "ResourceManager.h"
#include <iostream>

// Загрузка меша из файла
int ResourceManager::loadMesh(const string& filename) {
    // Проверяем, был ли уже загружен этот меш
    auto it = meshes_id.find(filename);
    if (it != meshes_id.end()) {
        cout << "Mesh already loaded: " << filename << " (index: " << it->second << ")\n";
        return it->second; // Возвращаем индекс уже загруженного меша
    }

    // Создаем новый меш и загружаем его из файла
    Mesh mesh;
    if (!mesh.load(filename)) {
        cerr << "Failed to load mesh: " << filename << "\n";
        return -1; // Возвращаем -1 в случае ошибки
    }

    // Добавляем меш в вектор и сохраняем его индекс
    int index = static_cast<int>(meshes.size());
    meshes.push_back(mesh);
    meshes_id[filename] = index;

    cout << "Mesh successfully loaded: " << filename << " (index: " << index << ")\n";
    return index;
}

// Получение меша по индексу
Mesh* ResourceManager::getMesh(int index) {
    if (index < 0 || index >= meshes.size()) {
        cerr << "Invalid mesh index: " << index << "\n";
        return nullptr;
    }
    return &meshes[index];
}

// Загрузка текстуры из файла
int ResourceManager::loadTexture(const string& filename) {
    // Проверяем, была ли уже загружена эта текстура
    auto it = textures_id.find(filename);
    if (it != textures_id.end()) {
        cout << "Texture already loaded: " << filename << " (index: " << it->second << ")\n";
        return it->second; // Возвращаем индекс уже загруженной текстуры
    }

    // Создаем новую текстуру и загружаем её из файла
    Texture texture;
    if (!texture.load(filename)) {
        cerr << "Failed to load texture: " << filename << "\n";
        return -1; // Возвращаем -1 в случае ошибки
    }

    // Добавляем текстуру в вектор и сохраняем её индекс
    int index = static_cast<int>(textures.size());
    textures.push_back(texture);
    textures_id[filename] = index;

    cout << "Texture successfully loaded: " << filename << " (index: " << index << ")\n";
    return index;
}

// Получение текстуры по индексу
Texture* ResourceManager::getTexture(int index) {
    if (index < 0 || index >= textures.size()) {
        cerr << "Invalid texture index: " << index << "\n";
        return nullptr;
    }
    return &textures[index];
}

// Вывод отладочной информации
void ResourceManager::printDebugInfo() const {
    cout << "Debug information:\n";
    cout << "Loaded meshes: " << meshes.size() << "\n";
    for (const auto& pair : meshes_id) {
        cout << "File: " << pair.first << " -> Index: " << pair.second << "\n";
    }
    cout << "Loaded textures: " << textures.size() << "\n";
    for (const auto& pair : textures_id) {
        cout << "Texture file: " << pair.first << " -> Index: " << pair.second << "\n";
    }
}