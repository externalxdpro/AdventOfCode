#include <format>
#include <fstream>
#include <iostream>
#include <unordered_map>

int partOne(std::ifstream &file) {
    std::string line;
    int sum = 0;
    while (std::getline(file, line)) {
        int l = -1, r = -1;

        for (auto it = line.begin(); it != line.end(); ++it) {
            if (l != -1 && r != -1)
                break;

            int lval = *it - 48;
            int rval = *(line.end() - (it - line.begin()) - 1) - 48;
            if (l == -1 && lval > 0 && lval <= 9)
                l = lval;
            if (r == -1 && rval > 0 && rval <= 9)
                r = rval;
        }
        sum += l * 10 + r;
    }

    return sum;
}

int partTwo(std::ifstream &file) {
    std::unordered_map<std::string, int> nums = {
        {"one", 1}, {"two", 2},   {"three", 3}, {"four", 4}, {"five", 5},
        {"six", 6}, {"seven", 7}, {"eight", 8}, {"nine", 9},
    };

    std::string line;
    int sum = 0;
    while (std::getline(file, line)) {
        int l = -1, r = -1;
        int lIn = -1, rIn = -1;

        for (auto it = line.begin(); it != line.end(); ++it) {
            if (l != -1 && r != -1)
                break;

            int lval = *it - 48;
            int rval = *(line.end() - (it - line.begin()) - 1) - 48;

            if (l == -1 && lval > 0 && lval <= 9) {
                l = lval;
                lIn = it - line.begin();
            }
            if (r == -1 && rval > 0 && rval <= 9) {
                r = rval;
                rIn = line.end() - it - 1;
            }
        }

        for (int i = 0; i < line.size(); i++) {
            for (int len = 3; len <= 5; len++) {
                std::string candidate = line.substr(i, len);
                if (nums[candidate] > 0) {
                    if (lIn == -1 || i < lIn) {
                        l = nums[candidate];
                        lIn = i;
                    }
                    if (rIn == -1 || i > rIn) {
                        r = nums[candidate];
                        rIn = i;
                    }
                }
            }
        }
        sum += l * 10 + r;
    }

    return sum;
}

int main() {
    std::ifstream file("input.txt");
    // std::cout << partOne(file) << std::endl;
    std::cout << partTwo(file) << std::endl;

    return 0;
}
