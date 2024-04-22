#include <bits/stdc++.h>

using namespace std;

int PartOne(vector<int> calories)
{
    vector<int>::iterator maxElem = max_element(calories.begin(), calories.end());
    return *maxElem;
}

int PartTwo(vector<int> calories)
{
    sort(calories.begin(), calories.end(), [] (int i, int j) {return i > j;});
    return calories[0] + calories[1] + calories[2];
}

int main()
{
    ifstream file("input.txt");
    string line;

    vector<int> calories = {};
    int elfIndex = 0;

    while (getline(file, line))
    {
        if (elfIndex >= calories.size())
            calories.push_back(0);

        if (line == "")
            elfIndex++;
        else
            calories[elfIndex] += stoi(line);
    }

    cout << "Part 1: " << PartOne(calories) << endl;
    cout << "Part 2: " << PartTwo(calories) << endl;
}
