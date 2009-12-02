Program Island(input,output);	{��һ�⣺˵�ѵ�}
const   inputfile            =  'island.in';
        outputfile           =  'island.out';
        MAXM                 =  200;
var     m,n                  :  integer;
        f                    :  array [1..MAXM,1..MAXM] of shortint;
        ans                  :  array [0..1] of set of byte;
        h                    :  array [1..MAXM] of boolean;
procedure noanswer;		{����޽�}
begin
  assign(output,outputfile);
  rewrite(output);
  writeln('NO ANSWER');
  close(output);
  halt;
end;
procedure initialize;		{�������ݡ�ʼ����}
var       a,b,c,d,i,j   :       integer;
begin
  assign(input,inputfile);
  reset(input);
  read(n,m);
  fillchar(f,sizeof(f),0);
  for i:=1 to n do
    begin
      read(a,b,c,d);
      if b<>d then		{���������ش�һ�£���������Ӧ����һ�µ�}
        begin
          if (f[a,c]=-1)or(f[c,a]=-1) then  {�����ǰ������ì�ܣ����޽�}
            begin
              close(input);
              noanswer;
            end;
          f[a,c]:=1;
          f[c,a]:=1;
        end
        else
          begin
            if (f[a,c]=1)or(f[c,a]=1) then  {�����ǰ������ì�ܣ����޽�}
              begin
                close(input);
                noanswer;
              end;
            f[a,c]:=-1;
            f[c,a]:=-1;
          end;
    end;
  close(input);
end;
procedure search(k,p:integer);		{�������������Ѱ��ͨ��ͼ}
var       i    :      integer;
begin
  ans[p]:=ans[p]+[k];			{����ǰ��������Ӽ�p}
  h[k]:=false;
  for i:=1 to m do
    if h[i] then
      case f[k,i] of
        -1  : search(i,1-p);		{�������i�뵱ǰ����𰸲�ͬ}
        1   : search(i,p);		{�������i�뵱ǰ�������ͬ}
      end;
end;
procedure solve;	{������}
var       a,b,i,j,no    :       integer;
          s             :       string;
begin
  no:=0;
  fillchar(h,sizeof(h),true);
  for i:=1 to m do	{������ͨ��ͼ}
    if h[i] then
      begin
        no:=no+1;
        ans[0]:=[];ans[1]:=[];	{����ͨ��ͼ�е������Ӽ���ʼ���ÿ�}
        search(i,0);		{��Ѱ��ͨ��ͼ}
        if ans[0]*ans[1]<>[] then noanswer;  {������Ӽ����ظ�Ԫ�أ���ì�ܣ��޽�}
        for a:=i to m do
          if a in (ans[0]+ans[1]) then
            for b:=i to m do
              if b in (ans[0]+ans[1]) then
                if f[a,b]<>0 then
                  if ((a in ans[0])xor(b in ans[0]))xor(f[a,b]=-1) then noanswer;
                     {��������������ͬ���Ӽ��������������ͬ��
                      ������������ͬһ�Ӽ�����������𰸲�ͬ����ì�ܣ��޽�}
      end;
  assign(output,outputfile);
  rewrite(output);
  s:='1';		{�߾��ȳ˷�}
  for i:=1 to no do
    begin
      if s[1]>='5' then s:='0'+s;
      a:=0;
      for j:=length(s) downto 1 do
        begin
          if s[j]>='5' then b:=1
            else b:=0;
          s[j]:=chr((ord(s[j])-48)*2 mod 10+a+48);
          a:=b;
        end;
    end;
  writeln(s);		{�����Ŀ�������}
  close(output);
end;
begin
  initialize;	{�������ݣ���ʼ��}
  solve;	{������}
end.