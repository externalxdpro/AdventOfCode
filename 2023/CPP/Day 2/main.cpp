#include <format>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_map>
#include <vector>

struct Round {
    int red = 0;
    int green = 0;
    int blue = 0;
};

std::vector<std::string> strSplit(std::string str, char del = ' ') {
    std::vector<std::string> result;
    std::stringstream ss(str);
    std::string splitted;
    while (std::getline(ss, splitted, del)) {
        result.push_back(splitted);
    }

    return result;
}

int partOne(std::ifstream &file) {
    const int MAX_RED = 12;
    const int MAX_GREEN = 13;
    const int MAX_BLUE = 14;

    std::unordered_map<int, std::vector<Round>> games;
    std::string line;
    int sum = 0;

    while (std::getline(file, line)) {
        std::vector<std::string> split1 = strSplit(line, ':');
        int id = std::stoi(strSplit(split1[0])[1]);

        std::vector<std::string> rounds = strSplit(split1[1], ';');

        for (auto round : rounds) {
            games[id].push_back(Round());

            std::vector<std::string> draws = strSplit(round, ',');
            for (auto draw : draws) {
                draw = draw.substr(1);
                std::vector<std::string> cubes = strSplit(draw);

                if (cubes[1] == "red") {
                    games[id].back().red = std::stoi(cubes[0]);
                } else if (cubes[1] == "green") {
                    games[id].back().green = std::stoi(cubes[0]);
                } else if (cubes[1] == "blue") {
                    games[id].back().blue = std::stoi(cubes[0]);
                } else {
                    std::cout << "how did you do this" << std::endl;
                }
            }
        }
    }

    for (auto rounds : games) {
        bool found = false;
        for (Round round : rounds.second) {
            if (round.red > MAX_RED || round.green > MAX_GREEN ||
                round.blue > MAX_BLUE) {
                found = true;
                break;
            }
        }
        if (!found) {
            sum += rounds.first;
        }
    }

    return sum;
}

int partTwo(std::ifstream &file) {
    std::unordered_map<int, Round> games;
    std::string line;
    int sum = 0;

    while (std::getline(file, line)) {
        std::vector<std::string> split1 = strSplit(line, ':');
        int id = std::stoi(strSplit(split1[0])[1]);
        games[id] = Round();

        std::vector<std::string> rounds = strSplit(split1[1], ';');

        for (auto round : rounds) {

            std::vector<std::string> draws = strSplit(round, ',');
            for (auto draw : draws) {
                draw = draw.substr(1);
                std::vector<std::string> cubes = strSplit(draw);

                int curr = std::stoi(cubes[0]);
                if (cubes[1] == "red" && curr > games[id].red) {
                    games[id].red = curr;
                } else if (cubes[1] == "green" && curr > games[id].green) {
                    games[id].green = curr;
                } else if (cubes[1] == "blue" && curr > games[id].blue) {
                    games[id].blue = curr;
                }
            }
        }
        sum += games[id].red * games[id].green * games[id].blue;
    }

    return sum;
}

int main() {
    std::ifstream file("input.txt");
    // std::ifstream file("example1.txt");

    // std::cout << partOne(file) << std::endl;
    std::cout << partTwo(file) << std::endl;
    return 0;
}
