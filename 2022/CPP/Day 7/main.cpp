#include <algorithm>
#include <iostream>
#include <fstream>
#include <stack>
#include <string>
#include <sstream>
#include <vector>

class Node {
public:
   std::string name;
   int size;
   std::vector<Node> children;

   Node(std::string name, int size) {
      this->name = name;
      this->size = size;
   }

   void AddChild(std::string name, int size) {
      this->children.push_back(Node(name, size));
   }

   void Print(int depth = 0) {
      for (int i = 0; i < depth; ++i) {
         if ( i != depth-1 ) std::cout << "    ";
         else std::cout << "|-- ";
      }
      
      if (this->size == 0) std::cout << this->name << " (dir)" << std::endl;
      else std::cout << this->name << " (" << this->size << ')' << std::endl;
      for (int i = 0 ; i < this->children.size() ; ++i) {
         this->children[i].Print(depth+1);
      }
   }
};

void CreateTree(Node *ptr) {
   std::ifstream file("input.txt");
   std::string line;
   std::stack<Node *> nodeStack;

   while(getline(file, line)) {
      std::istringstream ss(line);
      std::string word;
      ss >> word;
      if (word == "$") {
         ss >> word;
         if (word == "ls") continue;

         // cd
         ss >> word;

         if (word == "..") {
            ptr = nodeStack.top();
            nodeStack.pop();
            continue;
         }

         for (int i = 0; i < ptr->children.size(); i++) {
            if (ptr->children[i].name == word) {
               nodeStack.push(ptr);
               ptr = &(ptr->children[i]);

            }
         }
      }
      else if (word == "dir") {
         ss >> word;
         ptr->AddChild(word, 0);
      }
      else {
         int size = stoi(word);
         ss >> word;
         ptr->AddChild(word, size);
      }
   }
}

long long GetSize(Node &node) {
   if (node.size == 0) {
      int size = 0;
      for (Node child : node.children) {
         size += GetSize(child);
      }
      return size;
   }
   else return node.size;
}

int PartOne(Node &node) {
   if (node.size > 0) return 0;

   int totalSize = 0;

   for (Node child : node.children) {
      if (!child.size && GetSize(child) <= 100000) {
         totalSize += GetSize(child) + PartOne(child);
      }
      else totalSize += PartOne(child);
   }

   return totalSize;
}

long long PartTwo(Node *node, long long needed, long long lowest = 0) {
   if (node->size > 0) return lowest;

   for (Node child : node->children) {
      long long size = GetSize(child);
      if (!child.size && size >= needed && (lowest == 0 || size < lowest)) {
         lowest = size;
      }
      long long childSize = PartTwo(&child, needed, lowest);
      if (lowest == 0 || childSize < lowest) {
         lowest = childSize;
      }
   }

   return lowest;
}

int main() {
   Node node("/", 0);
   Node *ptr = &node;

   CreateTree(ptr);
   node.Print();
   std::cout << PartOne(node) << std::endl;

   long long needed = 30000000 - (70000000 - GetSize(node));
   std::cout << PartTwo(ptr, needed) << std::endl;
   
   return 0;
}
