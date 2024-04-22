#include <bits/stdc++.h>

using namespace std;

int PartOne()
{
    ifstream file("input.txt");
    string line;

    int score = 0;

    while (getline(file, line))
    {
        char opp = line[0];
        char you = line[2];

        if (you == 'X') score += 1;
        else if (you == 'Y') score += 2;
        else if (you == 'Z') score += 3;
        else { cout << "wha" << endl; return 0; }

        switch (opp)
        {
            case 'A':
                if (you == 'X') score += 3;
                else if (you == 'Y') score += 6;
                break;
            case 'B':
                if (you == 'Y') score += 3;
                else if (you == 'Z') score += 6;
                break;
            case 'C':
                if (you == 'X') score += 6;
                else if (you == 'Z') score += 3;
                break;
        }
    }

    return score;
}

int PartTwo()
{
    ifstream file("input.txt");
    string line;

    int score = 0;

    while (getline(file, line))
    {
        char opp = line[0];
        char result = line[2];

        switch (result)
        {
            case 'X':
                if (opp == 'A') score += 3;
                else if (opp == 'B') score += 1;
                else if (opp == 'C') score += 2;
                break;
            case 'Y':
                score += 3;
                if (opp == 'A') score += 1;
                else if (opp == 'B') score += 2;
                else if (opp == 'C') score += 3;
                break;
            case 'Z':
                score += 6;
                if (opp == 'A') score += 2;
                else if (opp == 'B') score += 3;
                else if (opp == 'C') score += 1;
                break;
        }
    }

    return score;
}

int main()
{
    cout << PartOne() << endl;
    cout << PartTwo() << endl;
    return 0;
}
