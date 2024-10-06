#include "Mesh.h"
#include <GL/GL.h>
#include <GL/glu.h>
#include <GL/glut.h>
using namespace std;

Mesh::Mesh() {};

void Mesh::load(const string& filename) {
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "Не удалось открыть файл: " << filename << endl;
        return;
    }

    vector<vec3> v; // Геометрические координаты
    vector<vec3> n; // Нормали
    vector<vec2> t; // Текстурные координаты
    vector<ivec3> fPoints; // Индексы атрибутов

    string line;
    while (getline(file, line)) {
        istringstream iss(line);
        string prefix;
        if (line.empty() || line[0] == '#') continue; // Игнорируем пустые строки и комментарии

        if (iss >> prefix) {
            if (prefix == "v") {
                vec3 vertex;
                if (iss >> vertex.x >> vertex.y >> vertex.z) {
                    v.push_back(vertex);
                }
            }
            else if (prefix == "vn") {
                vec3 normal;
                if (iss >> normal.x >> normal.y >> normal.z) {
                    n.push_back(normal);
                }
            }
            else if (prefix == "vt") {
                vec2 texCoord;
                if (iss >> texCoord.x >> texCoord.y) {
                    t.push_back(texCoord);
                }
            }
            else if (prefix == "f") {
                string vertexInfo;
                while (iss >> vertexInfo) {
                    replace(vertexInfo.begin(), vertexInfo.end(), '/', ' '); // Заменяем / на пробел
                    istringstream vertexStream(vertexInfo);
                    int posIndex, texIndex, normIndex;
                    vertexStream >> posIndex >> texIndex >> normIndex;
                    fPoints.push_back(ivec3(posIndex - 1, texIndex - 1, normIndex - 1)); // Индексы начинаются с 1
                }
            }
        }
    }

    // Построение массива вершин
    for (const auto& f : fPoints) {
        Vertex vertex;
        vertex.position = v[f.x];
        vertex.normal = n[f.z];
        vertex.texCoord = t[f.y];
        vertices.push_back(vertex);
    }

    cout << "Загружено вершин: " << vertices.size() << std::endl;
    file.close();
}

// Вывод меша
void Mesh::draw() {
    if (vertices.empty()) {
        cout << "Нет вершин для отрисовки!" << endl;
        return;
    }
    glBegin(GL_TRIANGLES);
    for (const auto& vertex : vertices) {
        glTexCoord2f(vertex.texCoord.x, vertex.texCoord.y);
        glNormal3f(vertex.normal.x, vertex.normal.y, vertex.normal.z);
        glVertex3f(vertex.position.x, vertex.position.y, vertex.position.z);
    }
    glEnd();

    //cout << "jdkw" << endl;
}