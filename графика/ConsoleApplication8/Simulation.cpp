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
