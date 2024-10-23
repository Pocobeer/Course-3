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
    //if (newPosition.x < -9 || newPosition.x >= 10 || newPosition.y < -9 || newPosition.y >= 10) {
    //    cout << "Collision with boundary at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
    //    return true; // ����� �� ������� �����
    //}
    // �������� �� ������� ��������, � �������� ������ ������
    if (passabilityMap[newPosition.y][newPosition.x] == 3) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 3 - ��� �������
    }
    return false; // ��� ��������
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
    }
    if (GetAsyncKeyState('S')) { // ���� ������ ������� S
        ivec2 newPos = player->getPosition();
        newPos.y += 1; // �������� ����
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'y'); // ����������� ������
        }
    }
    if (GetAsyncKeyState('A')) { // ���� ������ ������� A
        ivec2 newPos = player->getPosition();
        newPos.x -= 1; // �������� �����
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'x'); // ����������� ������
        }
    }
    if (GetAsyncKeyState('D')) { // ���� ������ ������� D
        ivec2 newPos = player->getPosition();
        newPos.x += 1; // �������� ������
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'x'); // ����������� ������
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
