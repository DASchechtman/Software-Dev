#include <iostream>

using namespace std;

void power(int base, int exponent);

int main(){
	power(2, 2);
	return 0;
}

void power(int base, int exponent) {
	int base_copy = 1;
	for (int i = 0; i < exponent; i++) {
		base_copy *= base;
	}
	cout << base_copy << '\n';
}
