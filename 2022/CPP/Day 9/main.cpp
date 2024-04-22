#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

struct pos {
    int x = 0, y = 0;
};

int main() {
    std::ifstream file("input2.txt");
    std::string line;

    pos h, t;
    while (getline(file, line)) {
        std::stringstream ss(line);
        char dir;
        int num;
        ss >> dir >> num;

        for (int i = 0; i < num; i++) {
            if (dir == 'U') {
                h.y++;
            } else if (dir == 'D') {
                h.y--;
            } else if (dir == 'L') {
                h.x--;
            } else if (dir == 'R') {
                h.x++;
            }

            if (abs(h.x - t.x) > 1 || abs(h.y - t.y) > 1) {
            }
        }
    }

    std::cout << "H: " << h.x << ' ' << h.y << std::endl;
    std::cout << "T: " << t.x << ' ' << t.y << std::endl;
    return 0;
}
