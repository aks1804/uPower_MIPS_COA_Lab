/*
This is the simulator for the uPOWER ISA.

Group Members
1. Pranav Vigneshwar Kumar - 181CO239
2. Ankush Chandrashekar - 181CO206
3. Mohammed Rushad - 181CO232
4. Akshat Nambiar - 181CO204
*/

#include <bits/stdc++.h>
#include <fstream>


using namespace std;



template <typename T>


void show_vector(vector<T> v)
{
	cout << endl
		 << "The vector is ";
	int i;
	for(long long i = 0; i < v.size(); ++i)
	{
		cout << v[i] << " ";
	}
	cout << endl;
}

struct Register
{
	long long s[32];
	long long lr, cr, srr0;
	long long cia, nia;
};
Register s;



#define gp s[28]
#define sp s[29]
#define fp s[30]
#define a0 s[4]
#define a1 s[5]
#define a2 s[6]
#define a3 s[7]
#define v0 s[2]
#define v1 s[3]

map<long long, vector<long long> > instr;
map<long long, long long> mem;

long long to_decimal(vector<long long> v)
{
	long long rv = 0;
	for(long long i = 0; i < v.size(); ++i)
	{
		rv = 2 * rv + v[i];
	}
	return rv;
}

long long to_signed_decimal(vector<long long> v)
{
	long long rv = 0;
	rv = -v[0];
	for(long long i = 0; i < v.size(); ++i)
	{
		rv = 2 * rv + v[i];
	}
	return rv;
}
struct fields
{
	long long po, rs, ra, rb, xo, rc;

	long long sh, sh2, sh1;
	long long rt, si, mb, me, bo, bi, bd, aa, lk, oe, ds, li;
};


fields i_instruction(vector<long long> v)
{
	fields p;
	vector<long long> po, li, aa, lk;
	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 30; ++i)
	{
		li.push_back(v[i]);
	}
	for(long long i = 30; i < 31; ++i)
	{
		aa.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		lk.push_back(v[i]);
	}
	p.po = to_decimal(po);
	p.li = to_decimal(li);
	p.aa = to_decimal(aa);
	p.lk = to_decimal(lk);

	return p;
}

fields x_instruction(vector<long long> v)
{
	fields p;
	vector<long long> po, rs, ra, rb, xo, rc;
	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rs.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 21; ++i)
	{
		rb.push_back(v[i]);
	}
	for(long long i = 21; i < 31; ++i)
	{
		xo.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		rc.push_back(v[i]);
	}
	p.po = to_decimal(po);
	p.rs = to_decimal(rs);
	p.ra = to_decimal(ra);
	p.rb = to_decimal(rb);
	p.xo = to_decimal(xo);
	p.rc = to_decimal(rc);

	return p;
}



fields xo_instruction(vector<long long> v)
{

	fields p;
	vector<long long> po, rt, ra, rb, oe, xo, rc;

	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rt.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 21; ++i)
	{
		rb.push_back(v[i]);
	}
	for (long long i = 21; i < 22; ++i)
	{
		oe.push_back(v[i]);
	}
    for(long long i = 22; i < 31; ++i)	
    {
		xo.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		rc.push_back(v[i]);
	}

	p.po = to_decimal(po);
	p.rt = to_decimal(rt);
	p.ra = to_decimal(ra);
	p.rb = to_decimal(rb);
	p.oe = to_decimal(oe);
	p.xo = to_decimal(xo);
	p.rc = to_decimal(rc);

	return p;
}

fields d_instruction(vector<long long> v)
{
	fields p;
	vector<long long> po, rt, ra, si;
	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rt.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 32; ++i)
	{
		si.push_back(v[i]);
	}
	p.po = to_decimal(po);
	p.rt = to_decimal(rt);
	p.ra = to_decimal(ra);
	p.si = to_decimal(si);

	return p;
}

fields xs_instruction(vector<long long> v)
{

	fields p;
	vector<long long> po, rs, ra, sh, xo, sh1, rc;

	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rs.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 21; ++i)
	{
		sh.push_back(v[i]);
	}
	for(long long i = 21; i < 30; ++i)
	{
		xo.push_back(v[i]);
	}
	for(long long i = 30; i < 31; ++i)
	{
		sh1.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		rc.push_back(v[i]);
	}

	p.po = to_decimal(po);
	p.rs = to_decimal(rs);
	p.ra = to_decimal(ra);
	p.sh = to_decimal(sh);
	p.xo = to_decimal(xo);
	p.sh1 = to_decimal(sh1);
	p.rc = to_decimal(rc);

	return p;
}

fields b_instruction(vector<long long> v)
{
	fields p;
	vector<long long> po, bo, bi, bd, aa, lk;
	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		bo.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		bi.push_back(v[i]);
	}
	for(long long i = 16; i < 30; ++i)
	{
		bd.push_back(v[i]);
	}
	for(long long i = 30; i < 31; ++i)
	{
		aa.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		lk.push_back(v[i]);
	}
	p.po = to_decimal(po);
	p.bo = to_decimal(bo);
	p.bi = to_decimal(bi);
	p.bd = to_decimal(bd);
	p.aa = to_decimal(aa);
	p.lk = to_decimal(lk);

	return p;
}

fields m_instruction(vector<long long> v)
{

	fields p;
	vector<long long> po, rs, ra, sh2, mb, me, rc;

	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rs.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 21; ++i)
	{
		sh2.push_back(v[i]);
	}
	for(long long i = 21; i < 26; ++i)
	{
		mb.push_back(v[i]);
	}
	for(long long i = 26; i < 31; ++i)
	{
		me.push_back(v[i]);
	}
	for(long long i = 31; i < 32; ++i)
	{
		rc.push_back(v[i]);
	}

	p.po = to_decimal(po);
	p.rs = to_decimal(rs);
	p.ra = to_decimal(ra);
	p.sh2 = to_decimal(sh2);
	p.mb = to_decimal(mb);
	p.me = to_decimal(me);
	p.rc = to_decimal(rc);

	return p;
}



fields ds_instruction(vector<long long> v)
{

	fields p;
	vector<long long> po, rt, ra, ds, xo;

	for(long long i = 0; i < 6; ++i)
	{
		po.push_back(v[i]);
	}
	for(long long i = 6; i < 11; ++i)
	{
		rt.push_back(v[i]);
	}
	for(long long i = 11; i < 16; ++i)
	{
		ra.push_back(v[i]);
	}
	for(long long i = 16; i < 30; ++i)
	{
		ds.push_back(v[i]);
	}
	for(long long i = 30; i < 32; ++i)
	{
		xo.push_back(v[i]);
	}

	p.po = to_decimal(po);
	p.rt = to_decimal(rt);
	p.ra = to_decimal(ra);
	p.ds = to_decimal(ds);
	p.xo = to_decimal(xo);

	return p;
}



void b(vector<long long> v)
{
	vector<long long> v2;
	for(long long i = 6; i < 30; ++i)
	{
		v2.push_back(v[i]);
	}
	long long change = to_signed_decimal(v2);
	s.nia = s.cia + change;
}

void add(vector<long long> v)
{

	fields p = xo_instruction(v);
	s.s[p.rt] = s.s[p.ra] + s.s[p.rb];
}

void addi(vector<long long> v)
{

	fields p = d_instruction(v);
	s.s[p.rt] = s.s[p.ra] + p.si;
}

void and2(vector<long long> v)
{
	fields p = x_instruction(v);
	s.s[p.ra] = s.s[p.rs] & s.s[p.rb];
}

void andi(vector<long long> v)
{
	fields p = d_instruction(v);
	s.s[p.rt] = s.s[p.ra] & p.si;
}

void extsw(vector<long long> v)
{
	fields p = x_instruction(v);
	long long temp = s.s[p.rs] & (4294967296 - 1); 
	s.s[p.ra] = temp;
	if (s.s[p.rs] & (1 << 31))
	{
		temp = (2 ^ 64 - 1) - (2 ^ 32 - 1);
		s.s[p.ra] += temp;
	}
}

void nand(vector<long long> v)
{
	fields p = x_instruction(v);
	s.s[p.ra] = !(s.s[p.rs] & s.s[p.rb]);
}

void lwz(vector<long long> v)
{

	fields p = d_instruction(v);
	s.s[p.rt] = mem[s.s[p.ra] + p.si];
}

void stw(vector<long long> v)
{

	fields p = d_instruction(v);
	mem[s.s[p.ra] + p.si + 4] = s.s[p.rt];
}

void xori(vector<long long> v)
{
	fields p = d_instruction(v);
	s.s[p.rt] = s.s[p.ra] ^ p.si;
}

void sld(vector<long long> v)
{
	fields p = x_instruction(v);
	long long temp = s.s[p.rb] & (2 ^ 7 - 1);
	s.s[p.ra] = s.s[p.rs] << temp;
}

void or2(vector<long long> v)
{
	fields p = x_instruction(v);
	s.s[p.ra] = s.s[p.rs] | s.s[p.rb];
}

void ori(vector<long long> v)
{
	fields p = d_instruction(v);
	s.s[p.rt] = s.s[p.ra] | p.si;
}

void xor2(vector<long long> v)
{
	fields p = x_instruction(v);
	s.s[p.ra] = s.s[p.rs] ^ s.s[p.rb];
}


void srd(vector<long long> v)
{
	fields p = x_instruction(v);
	long long temp = s.s[p.rb] & (2 ^ 7 - 1);
	s.s[p.ra] = s.s[p.rs] >> temp;
}

void srad(vector<long long> v)
{
	fields p = x_instruction(v);
	long long temp = s.s[p.rb] & (2 ^ 7 - 1);
	s.s[p.ra] = s.s[p.rs] >> temp;
	long long zero = 0;
	long long one = 1;
	if (s.s[p.rs] & (one << 63))
	{
		s.s[p.ra] |= ((~(zero) - ((one << (64 - temp)) - 1)));
	}
}

void cmp(vector<long long> v)
{
	fields p = x_instruction(v);
	s.cr >>= 4;
	s.cr <<= 4;
	long long a = s.s[p.rs], b = s.s[p.rb];
	if (a < b)
	{
		s.cr |= 8;
	}
	else if (a > b)
	{
		s.cr |= 4;
	}
	else
	{
		s.cr |= 2;
	}
}

void cmpi(vector<long long> v)
{

	fields p = d_instruction(v);
	s.cr >>= 4;
	s.cr <<= 4;
	long long a = s.s[p.ra], b = p.si;
	if (a < b)
	{
		s.cr |= 8;
	}
	else if (a > b)
	{
		s.cr |= 4;
	}
	else
	{
		s.cr |= 2;
	}
}

void sc(vector<long long> v)
{
	s.srr0 = s.nia;
	switch (s.s[2])
	{
	case 1:
	{
		cout << s.a0 << endl;
		break;
	}
	case 4:
	{
		long long temp = s.a0;
		while (mem[temp])
		{
			cout << (char)mem[temp];
			temp += 4;
		}
		cout << endl;
		break;
	}
	case 5:
	{
		long long temp;
		cin >> temp;
		s.s[3] = temp;
		break;
	}
	case 10:
	{
		cout << "Assembly code Read and exceuted succesfully " << endl;
		exit(0);
	}
	case 11:
	{
		cout << char(s.a0) << endl;
		break;
	}
	case 12:
	{
		char ch;
		cin >> ch;
		s.v0 = (long long)ch;
		break;
	}
	default:
	{
		cout << "Wrong argument for systemcall at instruction " << s.cia << endl;
		exit(0);
	}
	}
}

void bl(vector<long long> v)
{
	fields p = i_instruction(v);
	s.lr = s.cia + 4;
	s.nia += p.li;
}

void bclr(vector<long long> v)
{
	fields p = x_instruction(v);
	s.nia = s.lr;
}

void bc(vector<long long> v)
{
	fields p = b_instruction(v);
	if (p.bo == 28)
	{
		if ((1 << 3) & s.cr)
			s.nia = p.bd;
	}
	else if (p.bo == 29)
	{
		if ((1 << 2) & s.cr)
			s.nia = p.bd;
	}
	else
	{
		if ((1 << 1) & s.cr)
			s.nia = s.cia + p.bd;
	}
}

void opcode31(vector<long long> v)
{
	vector<long long> v2;
	for(long long i = 21; i < 31; ++i)
	{
		v2.push_back(v[i]);
	}
	long long XO = to_decimal(v2);

	switch (XO)
	{
	case 0:
		cmp(v);
		break;
	case 27:
		sld(v);
		break;
	case 28:
		and2(v);
		break;
	case 266:
		add(v);
		break;
	case 316:
		xor2(v);
		break;
	case 444:
		or2(v);
		break;
	case 476:
		nand(v);
		break;
	case 539:
		srd(v);
		break;
	case 794:
		srad(v);
		break;
	case 986:
		extsw(v);
		break;
	default:
	{
		cout << "wrong XO instruction " << s.cia << endl;
		exit(0);
	}
	}
}

void opcode(vector<long long> v)
{
	vector<long long> v2;
	for(long long i = 0; i < 6; ++i)
	{
		v2.push_back(v[i]);
	}
	long long opcode = to_decimal(v2);
	switch (opcode)
	{
	case 11:
		cmpi(v);
		break;
	case 14:
		addi(v);
		break;
	case 17:
		sc(v);
		break;
	case 18:
		b(v);
		break;
	case 19:
		bc(v);
		break;
	case 24:
		ori(v);
		break;
	case 26:
		xori(v);
		break;
	case 28:
		andi(v);
		break;
	case 31:
		opcode31(v);
		break;
	case 32:
		lwz(v);
		break;
	case 36:
		stw(v);
		break;

	default:
	{
		cout << "WRONG INSTRUCTION\n";
		exit(0);
	}
	}
}


void strins(vector<long long> v, long long num)
{
	instr[8417344 + (num * 4)] = v;
}

void strmem(vector<long long> v, long long num)
{
	long long val = to_signed_decimal(v);
	mem[num * 4] = val;
}

bool syscall(vector<long long> v)
{
	vector<long long> v2;
	for(long long i = 0; i < 6; ++i)
	{
		v2.push_back(v[i]);
	}
	return to_decimal(v2) == 17;
}
void start(long long num)
{
	if (instr[num].size() == 0)
	{
		cout << "Instruction not found\n";
		exit(0);
	}
	opcode(instr[num]);

	
	if (syscall(instr[num]))
	{
		s.cia = s.srr0;
	}
	else
	{
		s.cia = s.nia;
	}
	s.nia = s.cia + 4;
	start(s.cia);
}



void init()
{
	for(long long i = 0; i < 32; ++i)
	{
		s.s[i] = 0;
	}
	s.cia = 8417344;
	s.nia = 8417348;
	
	s.sp = 274877906928;
	mem[s.sp] = 0;
	s.gp = 32768 + 268435456;
	s.fp = s.sp;
}
int main()
{
	
	ifstream inFile;
	inFile.open("simulator_input.txt");

    vector<long long> input;
	char p;
	while (inFile >> p)
	{
		input.push_back(p - '0');
	}
	

	
	vector<long long> v;
	for(long long i = 0; i < 32; ++i)
	{
		v.push_back(input[0]);
		input.erase(input.begin());
	}
	long long text_size = to_decimal(v);
	
	v.clear();

	for(long long i = 0; i < 32; ++i)
	{
		v.push_back(input[0]);
		input.erase(input.begin());
	}
	long long data_size = to_decimal(v);
	
	


	for(long long i = 0; i < text_size; ++i)
	{
		v.clear();
		for(long long j = 0; j < 32; ++j)
		{
			v.push_back(input[0]);
			input.erase(input.begin());
		}
		strins(v, i);
	}

	for(long long i = 0; i < data_size; ++i)
	{
		v.clear();
		for(long long j = 0; j < 32; ++j)
		{
			v.push_back(input[0]);
			input.erase(input.begin());
		}
		strmem(v, i);
	}
	
	init();
	start(s.cia);
	

	return 0;
}
