#include <algorithm>
#include <cstdio>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

int PartOne()
{
    std::ifstream file("input.txt");
    std::string line;

    int sum = 0;

    while (getline(file, line))
    {
        std::string first = line.substr(0, line.size() / 2);
        std::string second = line.substr(line.size() / 2);

        char item = first[first.find_first_of(second)];

        int priority;
        if (item >= 'a') priority = item - 'a' + 1;
        else priority = item - 'A' + 27;
        sum += priority;
    }

    return sum;
}

int PartTwo()
{
    std::ifstream file("input.txt");

    int sum = 0;

    while (true)
    {
        std::string first, second, third;
        std::getline(file, first);
        if (first == "") break;

        std::getline(file, second);
        std::getline(file, third);

        int index = -1;
        while (true)
        {
            index = first.find_first_of(second, index + 1);
            char item = first[index];

            if (third.find_first_of(item) != std::string::npos)
            {
                int priority;
                if (item >= 'a') priority = item - 'a' + 1;
                else priority = item - 'A' + 27;
                sum += priority;

                break;
            }
        }
    }

    return sum;
}

int main() {

    std::cout << PartOne() << std::endl;
    std::cout << PartTwo() << std::endl;
    return 0;
}
