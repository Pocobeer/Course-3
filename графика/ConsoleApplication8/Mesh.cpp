#include "Mesh.h"

using namespace std;

Mesh::Mesh() {
    
    glGenBuffers(2, bufferIds);// Генерация двух буферов: bufferIds[0] для вершин и bufferIds[1] для индексов
}

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
    map<string, GLuint> vertexToIndexTable; // Ассоциативный контейнер для уникальных вершин

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
                for (int i = 0; i < 3; ++i) { // Обрабатываем только треугольники
                    if (iss >> vertexInfo) {
                        replace(vertexInfo.begin(), vertexInfo.end(), '/', ' '); // Заменяем / на пробел
                        istringstream vertexStream(vertexInfo);
                        int posIndex, texIndex, normIndex;
                        vertexStream >> posIndex >> texIndex >> normIndex;

                        // Создаем уникальный ключ для этой вершины
                        string key = to_string(posIndex) + "/" + to_string(texIndex) + "/" + to_string(normIndex);
                        GLuint index;

                        // Проверяем, использовалась ли вершина ранее
                        if (vertexToIndexTable.find(key) != vertexToIndexTable.end()) {
                            index = vertexToIndexTable[key]; // Получаем индекс существующей вершины
                        }
                        else {
                            // Создаем новую вершину и добавляем в массив
                            Vertex vertex;
                            vertex.position = v[posIndex - 1]; // Индексы начинаются с 1
                            vertex.normal = n[normIndex - 1];
                            vertex.texCoord = t[texIndex - 1];
                            index = static_cast<GLuint>(vertices.size());
                            vertices.push_back(vertex);
                            vertexToIndexTable[key] = index; // Сохраняем индекс новой вершины
                        }
                        indices.push_back(index); // Добавляем индекс в массив индексов
                    }
                }
            }
        }
    }
    //Загрузка данных в VBO
    glBindBuffer(GL_ARRAY_BUFFER, bufferIds[0]);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(Vertex), 
        vertices.data(), GL_STATIC_DRAW);

    GLenum error = glGetError(); // Проверка на ошибки
    if (error != GL_NO_ERROR) {
        cerr << "Ошибка при загрузке вершин: " << error << endl;
    }
    else {
        cout << "vetices good" << endl;
    }

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIds[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(GLuint),
        indices.data(), GL_STATIC_DRAW);

    error = glGetError(); // Проверка на ошибки
    if (error != GL_NO_ERROR) {
        cerr << "Ошибка при загрузке индексов: " << error << endl;
    }
    else {
        cout << "indicies are good" << endl;
    }

    cout << "Загружено вершин: " << vertices.size() << endl;
    cout << "Загружено индексов: " << indices.size() << endl;

    //отвязка буферов
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    file.close();
}

// Вывод меша
void Mesh::draw() {
    if (vertices.empty() || indices.empty()) {
        cout << "Нет вершин или индексов для отрисовки!" << endl;
        return;
    }

    // Привязываем буферы
    glBindBuffer(GL_ARRAY_BUFFER, bufferIds[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIds[1]);

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    // Устанавливаем указатели на массивы
    glVertexPointer(3, GL_FLOAT, sizeof(Vertex), (void*)offsetof(Vertex, position));
    glNormalPointer(GL_FLOAT, sizeof(Vertex), (void*)offsetof(Vertex, normal));
    glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), (void*)offsetof(Vertex, texCoord));

    // Рисуем с использованием индексов
    glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);

    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    // Отвязываем буферы
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}