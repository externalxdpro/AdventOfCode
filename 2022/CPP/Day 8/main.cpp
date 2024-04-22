#include <format>
#include <fstream>
#include <iostream>
#include <set>
#include <string>
#include <utility>
#include <vector>

std::ifstream file("input.txt");
std::string line;
std::vector<std::string> forest;

int PartOne() {
    std::set<std::pair<int, int>> coords;

    for (int i = 0; i < forest.size(); i++) {
        int tallest = -1;
        for (int j = 0; j < forest[i].size(); j++) {
            if (tallest < forest[i][j]) {
                tallest = forest[i][j];
                coords.emplace(i, j);
            }
        }

        tallest = -1;
        for (int j = forest[i].size() - 1; j >= 0; j--) {
            if (tallest < forest[i][j]) {
                tallest = forest[i][j];
                coords.emplace(i, j);
            }
        }
    }

    for (int j = 0; j < forest[0].size(); j++) {
        int tallest = -1;
        for (int i = 0; i < forest.size(); i++) {
            if (tallest < forest[i][j]) {
                tallest = forest[i][j];
                coords.emplace(i, j);
            }
        }

        tallest = -1;
        for (int i = forest.size() - 1; i >= 0; i--) {
            if (tallest < forest[i][j]) {
                tallest = forest[i][j];
                coords.emplace(i, j);
            }
        }
    }

    return coords.size();
}

int PartTwo() {
    int greatestScore = 0;

    for (int i = 1; i < forest.size() - 1; i++) {
        for (int j = 1; j < forest[i].size() - 1; j++) {
            int totalDistance;
            int up = 0, down = 0, left = 0, right = 0;
            // up
            for (int newI = i - 1; newI >= 0; newI--) {
                up++;
                if (forest[newI][j] >= forest[i][j])
                    break;
            }

            // down
            for (int newI = i + 1; newI < forest.size(); newI++) {
                down++;
                if (forest[newI][j] >= forest[i][j])
                    break;
            }

            // left
            for (int newJ = j - 1; newJ >= 0; newJ--) {
                left++;
                if (forest[i][newJ] >= forest[i][j])
                    break;
            }

            // right
            for (int newJ = j + 1; newJ < forest[i].size(); newJ++) {
                right++;
                if (forest[i][newJ] >= forest[i][j])
                    break;
            }

            int finalScore = up * down * left * right;
            if (finalScore > greatestScore)
                greatestScore = finalScore;
        }
    }

    return greatestScore;
}

int main() {
    while (getline(file, line)) {
        forest.push_back(line);
    }

    std::cout << PartOne() << std::endl;
    std::cout << PartTwo() << std::endl;

    return 0;
}
