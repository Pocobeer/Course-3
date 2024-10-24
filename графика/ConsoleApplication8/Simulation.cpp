#include "Simulation.h"

using namespace std;
// ���������� ������ (�� ��������� ����� ������� �� main.cpp)
extern Camera camera;
static LARGE_INTEGER frequency; // ������� �������
static LARGE_INTEGER lastTime; // ����� ���������� ������
static bool initialized = false; // ���� �������������

// ������� ��� ������������� ���������
void initSimulation() {
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&lastTime);
    initialized = true;
}

// ������� ��� ��������� ������� ���������
float getSimulationTime() {
    if (!initialized) {
        cerr << "Simulation not initialized!" << std::endl;
        return 0.0f;
    }

    LARGE_INTEGER currentTime;
    QueryPerformanceCounter(&currentTime);

    // ��������� �����, ��������� � ���������� ������ � ��������
    float deltaTime = static_cast<float>(currentTime.QuadPart - lastTime.QuadPart)/ frequency.QuadPart;



    // ��������� lastTime �� ������� �����
    lastTime = currentTime;

    return deltaTime;
}

bool checkCollision(const ivec2& newPosition) {
    // �������� ������ �����
    //if (newPosition.x <= 0 || newPosition.x >= 20 || newPosition.y <= 0 || newPosition.y >= 20) {
    //    cout << "Collision with boundary at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
    //    return true; // ����� �� ������� �����
    //}
    // �������� �� ������� ��������, � �������� ������ ������
    if (passabilityMap[newPosition.x][newPosition.y] == 2) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 2 - ��� �������
    }
    // �������� �� ������� ��������, � �������� ������ ������
    if (passabilityMap[newPosition.x][newPosition.y] == 3) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 3 - ��� �������
    }
    if (passabilityMap[newPosition.x][newPosition.y] == 3) {
        return false; // ��������� ��������
    }
    return false; // ��� ��������
}

void moveObject(const ivec2& newPosition, const ivec2& oldPosition) {
    // ��������� ����� ������������
    passabilityMap[newPosition.y][newPosition.x] = 1; // ������������� ����� ��������� �������
    passabilityMap[oldPosition.y][oldPosition.x] = 0; // ����������� ������ �����

    // ���������� ������� ������� � ����� ������� ������ (��������, � ������� ��������)
    // ��������, ��� ����� ����� �������� ������ ��������, ���� �� � ��� ����
     mapObjects[newPosition.y][newPosition.x] = mapObjects[oldPosition.y][oldPosition.x];
     mapObjects[oldPosition.y][oldPosition.x] = nullptr; // ����������� ������ �����
}

// ��������� ����� ��� ������
void keyboardFunc(float deltaTime) {
    // ���������� GetAsyncKeyState ��� ���������� �������
    if (GetAsyncKeyState(VK_UP)) {
        camera.rotateUpDown(50.0f * deltaTime); // �������� ������ �����
    }
    if (GetAsyncKeyState(VK_DOWN)) {
        camera.rotateUpDown(-50.0f * deltaTime); // �������� ������ ����
    }
    if (GetAsyncKeyState(VK_LEFT)) {
        camera.rotateLeftRight(-50.0f * deltaTime); // �������� ������ �����
    }
    if (GetAsyncKeyState(VK_LBUTTON)) {
        camera.rotateLeftRight(-50.0f * deltaTime); // �������� ������ �����
    }
    if (GetAsyncKeyState(VK_RBUTTON)) {
        camera.rotateLeftRight(50.0f * deltaTime); // �������� ������ ������
    }
    if (GetAsyncKeyState(VK_RIGHT)) {
        camera.rotateLeftRight(50.0f * deltaTime); // �������� ������ ������
    }
    if (GetAsyncKeyState(VK_ADD)) {
        camera.zoomInOut(-5.0f * deltaTime); // ����������� ������
    }
    if (GetAsyncKeyState(VK_SUBTRACT)) {
        camera.zoomInOut(5.0f * deltaTime); // ��������� ������
    }
    if (GetAsyncKeyState('W')) { // ���� ������ ������� W
        ivec2 newPos = player->getPosition();
        newPos.y -= 1; // �������� �����
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'y'); // ����������� ������
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // ���� ������ � ID 1, ���������� ���
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('S')) { // ���� ������ ������� S
        ivec2 newPos = player->getPosition();
        newPos.y += 1; // �������� ����
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'y'); // ����������� ������
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // ���� ������ � ID 1, ���������� ���
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('A')) { // ���� ������ ������� A
        ivec2 newPos = player->getPosition();
        newPos.x -= 1; // �������� �����
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'x'); // ����������� ������
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // ���� ������ � ID 1, ���������� ���
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('D')) { // ���� ������ ������� D
        ivec2 newPos = player->getPosition();
        newPos.x += 1; // �������� ������
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'x'); // ����������� ������
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // ���� ������ � ID 1, ���������� ���
            moveObject(newPos, player->getPosition());
        }
    }

}

// ������� ��������� - ���������� ����������� �����
void simulation() {
    // ����������� ������� ���������
    float deltaTime = getSimulationTime();

    // ��������� ����� � ���������� ��� ���������� �������
    keyboardFunc(deltaTime);

    // ������������� ������� ����, ��� ���� ��������� � �����������
    glutPostRedisplay();
}
