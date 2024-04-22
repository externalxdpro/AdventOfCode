#include <algorithm>
#include <fstream>
#include <iostream>
#include <stack>
#include <string>
#include <sstream>
#include <vector>

using std::ifstream;
using std::string;
using std::vector;

string PartOne(vector<std::stack<char>> stack)
{
    ifstream file("input.txt");
    string line;

    for (int i = 0; i < 10; i++)
        getline(file, line);

    while (getline(file, line))
    {
        std::stringstream ss(line);
        string word;
        vector<string> words;
        while (ss >> word) words.push_back(word);

        for (int i = 0; i < stoi(words[1]); i++)
        {
            int orig = stoi(words[3]) - 1, target = stoi(words[5]) - 1;
            stack[target].push(stack[orig].top());
            stack[orig].pop();
        }
    }

    string result;
    for (auto i : stack)
        result += i.top();

    return result;
}

string PartTwo(vector<std::stack<char>> stack)
{
    ifstream file("input.txt");
    string line;

    for (int i = 0; i < 10; i++)
        getline(file, line);

    while (getline(file, line))
    {
        std::stringstream ss(line);
        string word;
        vector<string> words;
        while (ss >> word) words.push_back(word);

        vector<char> temp;
        for (int i = 0; i < stoi(words[1]); i++)
        {
            int orig = stoi(words[3]) - 1;
            temp.push_back(stack[orig].top());
            stack[orig].pop();
        }
        std::reverse(temp.begin(), temp.end());
        for(char i : temp)
            stack[stoi(words[5]) - 1].push(i);
    }

    string result;
    for (auto i : stack)
        result += i.top();

    return result;
}

int main()
{
    ifstream file("input.txt");
    string line;

    vector<std::stack<char>> stack{};
    vector<string> lines;

    while (getline(file, line))
    {
        if (line[1] == '1')
        {
            int length = *(line.end() - 1) - '0';
            stack.resize(length);
            break;
        }

        lines.push_back(line);
    }

    for (auto i = lines.rbegin(); i != lines.rend(); ++i)
    {
        for (int j = 1; j < i->size(); j += 4)
        {
            char curr = i->at(j);
            if (curr != ' ')
                stack[(j - 1) / 4].push(curr);
        }
    }

    std::cout << PartOne(stack) << std::endl;
    std::cout << PartTwo(stack) << std::endl;

    return 0;
}
