#include <bits/stdc++.h> 
using namespace std;

string go(string s) {
	string t = s, ans = "";
	for(int i = 1; i <= 2; i ++) {
		t.pop_back();
		ans.push_back('\t');
	}
	ans.push_back('.');
	ans += s;
	ans.push_back('(');
	ans += t;
	ans.push_back(')');
	ans.push_back(',');
	return ans;
}

signed main()
{
	ofstream outfile;
	ifstream infile;
	outfile.open("./module_output.txt");
	infile.open("./module_input.txt");
	if(outfile.is_open() == 0) {
		cout << "outfile close" << endl;
		exit(0);
	}
	if(infile.is_open() == 0) {
		cout << "infile close" << endl;
		exit(0);
	}
	
	cout << "running\n" << endl;
	string buf;
	while(getline(infile, buf)) {
		istringstream is(buf);
		string word;
		while(is >> word) {
			if(word[word.size() - 1] == ',') word.pop_back();
			int sz = word.size();
			if(sz <= 2) continue;
			if((word[sz - 1] == 'i' || word[sz - 1] == 'o') && word[sz - 2] == '_') {
				string ans = go(word);
				outfile << ans << endl;
				cout << ans << endl;
			}
		}
	}
	system("pause");
	return 0;
}