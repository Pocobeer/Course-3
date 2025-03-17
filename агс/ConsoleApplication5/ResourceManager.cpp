#include "ResourceManager.h"
#include <iostream>

// �������� ���� �� �����
int ResourceManager::loadMesh(const string& filename) {
    // ���������, ��� �� ��� �������� ���� ���
    auto it = meshes_id.find(filename);
    if (it != meshes_id.end()) {
        cout << "Mesh already loaded: " << filename << " (index: " << it->second << ")\n";
        return it->second; // ���������� ������ ��� ������������ ����
    }

    // ������� ����� ��� � ��������� ��� �� �����
    Mesh mesh;
    if (!mesh.load(filename)) {
        cerr << "Failed to load mesh: " << filename << "\n";
        return -1; // ���������� -1 � ������ ������
    }

    // ��������� ��� � ������ � ��������� ��� ������
    int index = static_cast<int>(meshes.size());
    meshes.push_back(mesh);
    meshes_id[filename] = index;

    cout << "Mesh successfully loaded: " << filename << " (index: " << index << ")\n";
    return index;
}

// ��������� ���� �� �������
Mesh* ResourceManager::getMesh(int index) {
    if (index < 0 || index >= meshes.size()) {
        cerr << "Invalid mesh index: " << index << "\n";
        return nullptr;
    }
    return &meshes[index];
}

// �������� �������� �� �����
int ResourceManager::loadTexture(const string& filename) {
    // ���������, ���� �� ��� ��������� ��� ��������
    auto it = textures_id.find(filename);
    if (it != textures_id.end()) {
        cout << "Texture already loaded: " << filename << " (index: " << it->second << ")\n";
        return it->second; // ���������� ������ ��� ����������� ��������
    }

    // ������� ����� �������� � ��������� � �� �����
    Texture texture;
    if (!texture.load(filename)) {
        cerr << "Failed to load texture: " << filename << "\n";
        return -1; // ���������� -1 � ������ ������
    }

    // ��������� �������� � ������ � ��������� � ������
    int index = static_cast<int>(textures.size());
    textures.push_back(texture);
    textures_id[filename] = index;

    cout << "Texture successfully loaded: " << filename << " (index: " << index << ")\n";
    return index;
}

// ��������� �������� �� �������
Texture* ResourceManager::getTexture(int index) {
    if (index < 0 || index >= textures.size()) {
        cerr << "Invalid texture index: " << index << "\n";
        return nullptr;
    }
    return &textures[index];
}

// ����� ���������� ����������
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