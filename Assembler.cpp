#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string int_to_bin(int bits,int num) {
	string bin;
	bool negative = false;
	if (num < 0) {
		negative = true;
		num = num * -1;
	}
	for (int i = 0; i < bits; i++) {
		int value = 1 << (bits - i - 1);
		if (num >= value) {
			bin += "1";
			num -= value;
		}
		else {
			bin += "0";
		}
	}
	if (negative) {
		int one = 0;
		for (int i = bits-1; i >= 0; i--) {
			if (bin[i] == '1' && !one) {
				one++;
				continue;
			}
			else if (!one) {
				continue;
			}
			else if (bin[i] == '1') {
				bin[i] = '0';
			}
			else {
				bin[i] = '1';
			}
		}
	}
	return bin;
}

string bits_to_bytes(string bits) {
	string bytesflip="";
	
	for (int i = bits.size(); i > 0; i-=4) {
		int sum = 0;
		for (int j = 0; j < 4; j++) {
			if (bits[i-1-j] == '1') {
				sum += (1 << j);
			}
		}
		if (sum < 10) {
			bytesflip += to_string(sum);
		}
		else {
			bytesflip += 'A' + (sum - 10);
		}
	}
	string bytes = "";
	for (int i = bytesflip.size()-1; i >= 0; i--) {
		bytes += bytesflip[i];
		if (i % 2 == 0 && i!=0) {
			bytes += "\n";
		}
	}
	return bytes;
}

string I_type(string r, string n) {
	string mach_code = "";
	string rd, rs1, imm;
	int ird, irs1, iimm;
	int spaces = 0;
	int bracket = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (r[i] == '(') {
			imm = rs1;
			rs1 = "";
			continue;
		}
		else if (r[i] == ')') {
			continue;
		}
		else if (spaces == 0) {
			rd += r[i];
		}
		else if (spaces == 1) {
			rs1 += r[i];
		}
		else {
			imm += r[i];
		}
	}
	ird = stoi(rd);
	irs1 = stoi(rs1);
	iimm = stoi(imm);
	if (n != "slli") {
		mach_code += int_to_bin(12, iimm);
	}
	else {
		mach_code += "0000000";
		mach_code += int_to_bin(5, iimm);
	}
	mach_code += int_to_bin(5, irs1);
	if (n == "andi") {
		mach_code += "000";
	}
	else if (n == "slli") {
		mach_code += "010";
	}
	else if (n == "lh") {
		mach_code += "100";
	}
	else if (n == "lw") {
		mach_code += "011";
	}
	else if (n == "ori") {
		mach_code += "111";
	}
	else {
		mach_code += "001";
	}
	mach_code += int_to_bin(5, ird);
	if (n == "jalr") {
		mach_code += "1101000";
	}
	else {
		mach_code += "0010100";
	}
	return mach_code;
}

string SB_type(string r, string n) {
	string mach_code = "";
	string rs1, rs2, imm;
	int irs1, irs2, iimm;
	int spaces = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (spaces == 0) {
			rs1 += r[i];
		}
		else if (spaces == 1) {
			rs2 += r[i];
		}
		else {
			imm += r[i];
		}
	}
	irs1 = stoi(rs1);
	irs2 = stoi(rs2);
	iimm = stoi(imm);
	imm = int_to_bin(12, iimm);
	mach_code += imm[0];
	for (int i=2; i<8; i++) {
		mach_code += imm[i];
	}
	mach_code += int_to_bin(5, irs2);
	mach_code += int_to_bin(5, irs1);
	if (n == "bge") {
		mach_code += "110";
	}
	else {
		mach_code += "010";
	}
	for (int i=8 ; i<12; i++) {
		mach_code += imm[i];
	}
	mach_code += imm[1];
	mach_code += "1100100";
	return mach_code;
}

string U_type(string r, string n) {
	string mach_code = "";
	string rd, imm;
	int ird, iimm;
	int spaces = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (spaces == 0) {
			rd += r[i];
		}
		else if (spaces == 1) {
			imm += r[i];
		}
	}
	ird = stoi(rd);
	iimm = stoi(imm);
	mach_code += int_to_bin(20, iimm);
	mach_code += int_to_bin(5, ird);
	mach_code += "0111000";
	return mach_code;
}

string UJ_type(string r, string n) {
	string mach_code = "";
	string rd, imm;
	int ird, iimm;
	int spaces = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (spaces == 0) {
			rd += r[i];
		}
		else if (spaces == 1) {
			imm += r[i];
		}
	}
	ird = stoi(rd);
	iimm = stoi(imm);
	imm = int_to_bin(20, iimm);
	mach_code += imm[0];
	for (int i = 10; i <20; i++) {
		mach_code += imm[i];
	}
	mach_code += imm[9];
	for (int i = 1; i < 9; i++) {
		mach_code += imm[i];
	}
	mach_code += int_to_bin(5, ird);
	mach_code += "1110000";
	return mach_code;
}

string S_type(string r, string n) {
	string mach_code = "";
	string rs1, rs2, imm;
	int irs1, irs2, iimm;
	int spaces = 0;
	int bracket = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (r[i] == '(' ||	r[i] == ')') {
			bracket++;
			continue;
		}
		else if (spaces == 0) {
			rs2 += r[i];
		}
		else if (spaces == 1 && !bracket) {
			imm += r[i];
		}
		else if (bracket == 1) {
			rs1 += r[i];
		}
	}
	irs1 = stoi(rs1);
	irs2 = stoi(rs2);
	iimm = stoi(imm);
	imm = int_to_bin(12, iimm);
	for (int i = 0; i < 7; i++) {
		mach_code += imm[i];
	}
	mach_code += int_to_bin(5, irs2);
	mach_code += int_to_bin(5, irs1);
	if (n == "sb") {
		mach_code += "001";
	}
	else {
		mach_code += "011";
	}
	for (int i = 7; i < 12; i++) {
		mach_code += imm[i];
	}
	mach_code += "0100100";
	return mach_code;
}

string R_type(string r,string n) {
	string mach_code = "";
	string rd, rs1, rs2;
	int ird, irs1, irs2;
	int spaces = 0;
	for (int i = 0; i < r.length(); i++) {
		if (r[i] == ' ') {
			spaces++;
			continue;
		}
		else if (spaces == 0) {
			rd += r[i];
		}
		else if (spaces == 1) {
			rs1 += r[i];
		}
		else {
			rs2 += r[i];
		}
	}

	ird = stoi(rd);
	irs1 = stoi(rs1);
	irs2 = stoi(rs2);

	if (n == "sltu") {
		mach_code += "0000001";
	}
	else if (n == "sra" || n == "sub") {
		mach_code += "0110000";
	}
	else {
		mach_code += "0010000";
	}

	mach_code += int_to_bin(5, irs2);
	mach_code += int_to_bin(5, irs1);
	
	if (n == "and") {
		mach_code += "000";
	}
	else if (n == "xor") {
		mach_code += "101";
	}
	else if (n == "or") {
		mach_code += "111";
	}
	else if (n == "sltu") {
		mach_code += "100";
	}
	else if (n == "srl" || n == "sra") {
		mach_code += "110";
	}
	else {
		mach_code += "001";
	}
	mach_code += int_to_bin(5, ird);
	mach_code += "0110100";

	return mach_code;
}

int main(int argc, char* argv[]) {
	if (argc < 3) {
		cout << "Argument missing\nCorrect usage: ./assembler <input> <output>";
		return 0;
	}
	const char* assembly_file = argv[1];
	const char* machine_code_file = argv[2];

	ifstream input(assembly_file);
	if (!input) {
		cout << "Could not open assembly file";
		return 0;
	}
	ofstream output(machine_code_file);
	string line;
	while (getline(input, line)) {
		int i = 0;
		string mnemonic = "";
		while (line[i] != ' ' && i < line.length()) {
			mnemonic += line[i];
			i++;
		}
		i++;
		string regs;
		while (i < line.length()) {
			if (line[i] != ',' && line[i]!='x') {
				regs += line[i];
			}
			i++;
		}
		if (line == "NOP") {
			continue;
		}
		else if (mnemonic == "addiw" || mnemonic == "andi" || mnemonic == "jalr" || mnemonic == "lh" || mnemonic == "lw" || mnemonic == "ori" || mnemonic == "slli") {
			output << bits_to_bytes(I_type(regs, mnemonic)) << "\n";
		}
		else if (mnemonic == "bge" || mnemonic == "bne") {
			output << bits_to_bytes(SB_type(regs, mnemonic)) << "\n";
		}
		else if (mnemonic == "lui") {
			output << bits_to_bytes(U_type(regs, mnemonic)) << "\n";
		}
		else if (mnemonic == "jal") {
			output << bits_to_bytes(UJ_type(regs, mnemonic)) << "\n";
		}
		else if (mnemonic == "sb" || mnemonic == "sw") {
			output << bits_to_bytes(S_type(regs, mnemonic)) << "\n";
		}
		else {
			output << bits_to_bytes(R_type(regs,mnemonic)) << "\n";
		}
	}
	return 0;
}