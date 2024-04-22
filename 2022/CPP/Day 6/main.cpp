#include <bits/stdc++.h>

using namespace std;

int PartOne(string str)
{
    int numChars = 4;
    for (int i = 0; i <= str.size() - numChars; i++)
    {
        string packet = str.substr(i, numChars);
        
        bool found = false;
        for (int j = 0; j < packet.size(); j++)
        {
            if (packet.find_first_of(packet[j], j + 1) != string::npos)
            {
                found = true;
                break;
            }
        }

        if (!found) return i + numChars;
    }

    return -1;
}

int PartTwo(string buffer)
{
    int numChars = 14;
    for (int i = 0; i <= buffer.size() - numChars; i++)
    {
        string packet = buffer.substr(i, numChars);
        
        bool found = false;
        for (int j = 0; j < packet.size(); j++)
        {
            if (packet.find_first_of(packet[j], j + 1) != string::npos)
            {
                found = true;
                break;
            }
        }

        if (!found) return i + numChars;
    }

    return -1;
}

int main()
{
    ifstream input("input.txt");
    string line;
    getline(input, line);
    
    cout << PartOne(line) << endl;
    cout << PartTwo(line) << endl;

    return 0;
}
