#include <bits/stdc++.h>
using namespace std;

signed main()
{
    ofstream out_file;
    ifstream in_file;

    in_file.open("./instr_mem_assembly.txt"); // 以读模式打开文件
    out_file.open("./instr_mem.txt"); // 以写模式打开文件

    if(in_file.is_open() == 0) {
        cout << "in_file is wrong !" << endl;
        return 0;
    }
    if(out_file.is_open() == 0) {
        cout << "out_file is wrong !" << endl;
        return 0;
    }
    cout << "success !" << endl;

    string buf;
    int cnt = 0;
    while(getline(in_file, buf)) {
    	// cout << typeid(buf).name() << endl;
		string ans = "";
		for(int i = 15; i <= 22; i ++) {
			ans.push_back(buf[i]);
			if(i == 16 || i == 18 || i== 20) ans.push_back(' ');
		}
		ans.push_back('\n');
		if((ans[0] >= '0' && ans[0] <= '9') || (ans[0] >= 'a' && ans[0] <= 'f')) {
			cout << ans << endl;
			cnt ++;
			out_file << ans << endl;
		}
    }
	cout << "all: " << cnt << endl;
	
    in_file.close();
    out_file.close();

    system("pause");
    return 0;
}