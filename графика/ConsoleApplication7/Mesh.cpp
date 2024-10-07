#include "Mesh.h"

using namespace std;

Mesh::Mesh() {}

void Mesh::load(const string& filename) {
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "�� ������� ������� ����: " << filename << endl;
        return;
    }

    vector<vec3> v; // �������������� ����������
    vector<vec3> n; // �������
    vector<vec2> t; // ���������� ����������
    vector<ivec3> fPoints; // ������� ���������

    string line;
    map<string, GLuint> vertexToIndexTable; // ������������� ��������� ��� ���������� ������

    while (getline(file, line)) {
        istringstream iss(line);
        string prefix;
        if (line.empty() || line[0] == '#') continue; // ���������� ������ ������ � �����������

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
                for (int i = 0; i < 3; ++i) { // ������������ ������ ������������
                    if (iss >> vertexInfo) {
                        replace(vertexInfo.begin(), vertexInfo.end(), '/', ' '); // �������� / �� ������
                        istringstream vertexStream(vertexInfo);
                        int posIndex, texIndex, normIndex;
                        vertexStream >> posIndex >> texIndex >> normIndex;

                        // ������� ���������� ���� ��� ���� �������
                        string key = to_string(posIndex) + "/" + to_string(texIndex) + "/" + to_string(normIndex);
                        GLuint index;

                        // ���������, �������������� �� ������� �����
                        if (vertexToIndexTable.find(key) != vertexToIndexTable.end()) {
                            index = vertexToIndexTable[key]; // �������� ������ ������������ �������
                        }
                        else {
                            // ������� ����� ������� � ��������� � ������
                            Vertex vertex;
                            vertex.position = v[posIndex - 1]; // ������� ���������� � 1
                            vertex.normal = n[normIndex - 1];
                            vertex.texCoord = t[texIndex - 1];
                            index = static_cast<GLuint>(vertices.size());
                            vertices.push_back(vertex);
                            vertexToIndexTable[key] = index; // ��������� ������ ����� �������
                        }
                        indices.push_back(index); // ��������� ������ � ������ ��������
                    }
                }
            }
        }
    }

    cout << "��������� ������: " << vertices.size() << endl;
    cout << "��������� ��������: " << indices.size() << endl;
    file.close();
}

// ����� ����
void Mesh::draw() {
    if (vertices.empty() || indices.empty()) {
        cout << "��� ������ ��� �������� ��� ���������!" << endl;
        return;
    }

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    // ������������� ��������� �� �������
    glVertexPointer(3, GL_FLOAT, sizeof(Vertex), &vertices[0].position);
    glNormalPointer(GL_FLOAT, sizeof(Vertex), &vertices[0].normal);
    glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &vertices[0].texCoord);

    // ������ � �������������� ��������
    glDrawElements(GL_TRIANGLES, static_cast<GLsizei>(indices.size()), GL_UNSIGNED_INT, indices.data());

    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}