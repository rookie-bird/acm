{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program FireOfTheArtGallery;
const
	MaxN=100;	{N������}
type
	TPrevious=array [0..100,0..100] of	{���淽����Ϣ������}
		record
			k,	{��5��ʽ�ӵ���һ���������}
			t	:byte;	{���߱���t}
		end;
	TBest=array [0..100,0..100] of longint;	{����ֵ����F������}
var
	N,			{����ÿ�е�Ԫ����N}
	K	:byte;	{�Ӿ������K}
	Value	:array [1..2,1..MaxN] of integer;	{����W������V-����F}
	Best	:array [0..1] of ^TBest;			{����ֵ����F}
	Prev	:array [0..10] of ^TPrevious;	{���淽����Ϣ}

procedure ReadIn;	{����}
var
	i,j	:byte;
	t	:integer;
begin
	reset(input);
	readln(N,K);
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
			read(Value[i,j]);	{��ʱ������Ǿ���V}
		readln;
	end;
	for i:=2 downto 1 do
	begin
		for j:=1 to N do
		begin
			read(t);				{����F��(i,j)Ԫ��}
			dec(Value[i,j],t);	{��Ӧ����þ���W}
		end;
		readln;
	end;
	close(input);
end;

procedure Work;	{�滮������}
var
	s,i,j,t	:shortint;
	sum	:longint;
begin
	new(Best[0]); new(Best[1]);
	fillchar(Best[0]^,sizeof(Best[0]^),0);	{�߽�����}
	new(Prev[0]);
	fillchar(Prev[0]^,sizeof(Prev[0]^),0);
	for s:=1 to K do	{�׶α���ѭ��}
	begin
		new(Prev[s]);
		for i:=0 to N do
			for j:=0 to N do	{״̬����ѭ��}
			begin
				Best[s and 1]^[i,j]:=0;
				Prev[s]^[i,j].k:=0;
				{����ֱ����滮�����е����ʽ��}
				if (i>0) and (Best[s and 1]^[i-1,j]<Best[s and 1]^[i,j]) then
				begin	{��һ��}
					Best[s and 1]^[i,j]:=Best[s and 1]^[i-1,j];
					Prev[s]^[i,j].k:=1;
				end;
				if (j>0) and (Best[s and 1]^[i,j-1]<Best[s and 1]^[i,j]) then
				begin	{�ڶ���}
					Best[s and 1]^[i,j]:=Best[s and 1]^[i,j-1];
					Prev[s]^[i,j].k:=2;
				end;
				sum:=0;
				if i>j
				then for t:=i-1 downto 0 do	{������}
					begin
						inc(sum,Value[1,t+1]);
						if sum>=0 then break;	{��ʱ����ֵ���������ڴ���ֵ}
						if Best[s and 1 xor 1]^[t,j]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[t,j]+sum;
							Prev[s]^[i,j].k:=3;
							Prev[s]^[i,j].t:=t;
						end;
					end
				else for t:=j-1 downto 0 do	{���ĸ�}
					begin
						inc(sum,Value[2,t+1]);
						if sum>=0 then break;
						if Best[s and 1 xor 1]^[i,t]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[i,t]+sum;
							Prev[s]^[i,j].k:=4;
							Prev[s]^[i,j].t:=t;
						end;
					end;
				sum:=0;
				if i=j then
					for t:=j-1 downto 0 do	{�����}
					begin
						inc(sum,Value[1,t+1]+Value[2,t+1]);
						if sum>=0 then break;
						if Best[s and 1 xor 1]^[t,t]+sum<Best[s and 1]^[i,j] then
						begin
							Best[s and 1]^[i,j]:=Best[s and 1 xor 1]^[t,t]+sum;
							Prev[s]^[i,j].k:=5;
							Prev[s]^[i,j].t:=t;
						end;
					end;
			end;
	end;
end;

procedure Print;	{��ӡ}
var
	s,i,j	:byte;
begin
	rewrite(output);
	s:=K; i:=N; j:=N;
	while Prev[s]^[i,j].k>0 do
		case Prev[s]^[i,j].k of
			1 : dec(i);	{1,2������������ڴ��У�����Ҫ�Ӿ���}
			2 : dec(j);
			3 : begin	{������������ֱ��ӡ�����Ӿ���}
					writeln('1 ',Prev[s]^[i,j].t+1,' 1 ',i);
					i:=Prev[s]^[i,j].t;
					dec(s);
				end;
			4 : begin
					writeln('2 ',Prev[s]^[i,j].t+1,' 2 ',j);
					j:=Prev[s]^[i,j].t;
					dec(s);
				end;
			5 : begin
					writeln('1 ',Prev[s]^[i,j].t+1,' 2 ',i);
					i:=Prev[s]^[i,j].t;
					j:=i;
					dec(s);
				end;
		end;
	for i:=1 to s do	{�����ķ������0}
		writeln('0 0 0 0');
	close(output);
end;

begin
	assign(input,'input.txt');
	assign(output,'output.txt');
	ReadIn;
	Work;
	Print;
end.