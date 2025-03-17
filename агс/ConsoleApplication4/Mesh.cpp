#include "Mesh.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <algorithm>
#include <glm/glm.hpp>

using namespace std;
using namespace glm;

Mesh::Mesh() : vao(0), vertexBuffer(0), indexBuffer(0), vertexCount(0) {}

bool Mesh::load(const  string& filename) {
    vector<Vertex> vertices;
    vector<GLuint> indices;

    loadObjFile(filename, vertices, indices);

    // Загружаем данные из файла
    if (!loadObjFile(filename, vertices, indices)) {
        cerr << "Failed to load mesh data from file: " << filename << endl;
        return false;
    }

    // Создаем буферы OpenGL
    createBuffers(vertices, indices);

    return true;
}

void Mesh::drawOne() {
    if (vao == 0) return;

    glBindVertexArray(vao);
    glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_INT, nullptr);
    glBindVertexArray(0);
}

bool Mesh::loadObjFile(const  string& filename,  vector<Vertex>& vertices,  vector<GLuint>& indices) {
     ifstream file(filename);
    if (!file.is_open()) {
         cerr << "Can't open file: " << filename <<  endl;
        return false;
    }

     vector<vec3> tempCoords;
     vector< vec3> tempNormals;
     vector< vec2> tempTexCoords;
     vector<GLuint> coordIndices, normalIndices, texCoordIndices;

     string line;
    while ( getline(file, line)) {
         istringstream iss(line);
         string type;
        iss >> type;

        if (type == "v") { // Вершины
             vec3 coord;
            iss >> coord.x >> coord.y >> coord.z;
            tempCoords.push_back(coord);
        }
        else if (type == "vn") { // Нормали
             vec3 normal;
            iss >> normal.x >> normal.y >> normal.z;
            tempNormals.push_back(normal);
        }
        else if (type == "vt") { // Текстурные координаты
             vec2 texCoord;
            iss >> texCoord.x >> texCoord.y;
            tempTexCoords.push_back(texCoord);
        }
        else if (type == "f") { // Грани
            for (int i = 0; i < 3; ++i) {
                 string face;
                iss >> face;
                 replace(face.begin(), face.end(), '/', ' ');
                 istringstream faceIss(face);
                GLuint coordIndex, texCoordIndex, normalIndex;
                faceIss >> coordIndex >> texCoordIndex >> normalIndex;

                coordIndices.push_back(coordIndex - 1);
                texCoordIndices.push_back(texCoordIndex - 1);
                normalIndices.push_back(normalIndex - 1);
            }
        }
    }

    // Сборка вершин
    for (size_t i = 0; i < coordIndices.size(); ++i) {
        Vertex vertex;
        vertex.coord[0] = tempCoords[coordIndices[i]].x;
        vertex.coord[1] = tempCoords[coordIndices[i]].y;
        vertex.coord[2] = tempCoords[coordIndices[i]].z;

        vertex.normal[0] = tempNormals[normalIndices[i]].x;
        vertex.normal[1] = tempNormals[normalIndices[i]].y;
        vertex.normal[2] = tempNormals[normalIndices[i]].z;

        vertex.texCoord[0] = tempTexCoords[texCoordIndices[i]].x;
        vertex.texCoord[1] = tempTexCoords[texCoordIndices[i]].y;

        vertices.push_back(vertex);
    }

    // Сборка индексов
    for (size_t i = 0; i < coordIndices.size(); ++i) {
        indices.push_back(i);
    }

    vertexCount = static_cast<int>(indices.size());

    return true;
}

void Mesh::createBuffers(const  vector<Vertex>& vertices, const  vector<GLuint>& indices) {
    // Создание VAO
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    // Создание VBO для вершин
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(Vertex), vertices.data(), GL_STATIC_DRAW);

    // Установка атрибутов вершин
    // Атрибут 0: координаты
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, coord));
    glEnableVertexAttribArray(0);

    // Атрибут 1: нормали
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, normal));
    glEnableVertexAttribArray(1);

    // Атрибут 2: текстурные координаты
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, texCoord));
    glEnableVertexAttribArray(2);

    // Создание IBO для индексов
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(GLuint), indices.data(), GL_STATIC_DRAW);

    // Отвязка VAO
    glBindVertexArray(0);
}