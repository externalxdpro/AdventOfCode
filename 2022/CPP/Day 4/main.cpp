#include <fstream>
#include <iostream>
#include <utility>

using namespace std;

int PartOne()
{
    ifstream file("input.txt");
    string line;

    int overlaps = 0;

    while(getline(file, line))
    {
        int comma = line.find(',');
        string p1 = line.substr(0, comma);
        string p2 = line.substr(comma + 1);

        int p1dash = p1.find('-');
        int p2dash = p2.find('-');
        pair<int, int> p1nums = {stoi(p1.substr(0, p1dash)), stoi(p1.substr(p1dash + 1))};
        pair<int, int> p2nums = {stoi(p2.substr(0, p2dash)), stoi(p2.substr(p2dash + 1))};

        if ((p1nums.first >= p2nums.first && p1nums.second <= p2nums.second) ||
            (p2nums.first >= p1nums.first && p2nums.second <= p1nums.second))
            overlaps++;
    }

    return overlaps;
}

int PartTwo()
{
    ifstream file("input.txt");
    string line;

    int overlaps = 0;

    while(getline(file, line))
    {
        int comma = line.find(',');
        string p1 = line.substr(0, comma);
        string p2 = line.substr(comma + 1);

        int p1dash = p1.find('-');
        int p2dash = p2.find('-');
        pair<int, int> p1nums = {stoi(p1.substr(0, p1dash)), stoi(p1.substr(p1dash + 1))};
        pair<int, int> p2nums = {stoi(p2.substr(0, p2dash)), stoi(p2.substr(p2dash + 1))};

        if ((p1nums.first >= p2nums.first && p1nums.first <= p2nums.second) ||
            (p1nums.second >= p2nums.first && p1nums.second <= p2nums.second) ||
            (p2nums.first >= p1nums.first && p2nums.first <= p1nums.second) ||
            (p2nums.second >= p1nums.first && p2nums.second <= p1nums.second))
            overlaps++;
    }

    return overlaps;
}

int main()
{

    cout << PartOne() << endl;
    cout << PartTwo() << endl;
    return 0;
}
