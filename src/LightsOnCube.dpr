library lightsoncube;

uses SysUtils,Classes,Math;

{$R *.res}

const RIFF=1179011410;
const HEAD: array[0..31] of byte = (
$57, $41, $56, $45, $66, $6D, $74, $20, $10, $00, $00, $00, $01, $00, $01, $00,
$44, $AC, $00, $00, $88, $58, $01, $00, $02, $00, $10, $00, $64, $61, $74, $61
);
type wav=record
riff:Cardinal;
sz_8:Cardinal;
head:array[0..31] of byte;
sz_44:Cardinal;
mel:array[0..441000] of word;
end;

var
stream:TFileStream;
i,x,n:integer;
y:real;
w:wav;
a,b:integer;
temp:array [0..1023] of char;

function GetTempPathA(s:integer;t:pchar):integer;stdcall;external 'kernel32.dll';

function f1(x:integer):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=sin(2*pi*t*a)*exp(-t*3)*(sin(2*pi*3*t)+sin(2*pi*b*t))/2;
Result:=Round(r*32766*(n-x)/n);
end;

function f2(x:integer):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=sin(2*pi*3*t*(1+(1+sin(2*pi*t*a))/1))*exp(-t*4)/2;
Result:=Round(r*32766);
end;

function f3(x:integer;y:Real):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=0.7*sin(2*pi*t*a)+0.3*sign(sin(2*pi*t*a*1.01));
Result:=Round(r*32766*y);
end;

function f4(x:integer):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=sin(a*t+sin(200*t*t*exp(-t/8))*8);
Result:=Round(r*32766*((n-x)/n));
end;

function f5(x:integer):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=sin(2*pi*t*a)*exp(-t*10)*(1-exp(-t*20))*2;
Result:=Round(r*32766);
end;

function f6(x:integer):Smallint;
var r,t:Real;
begin
t:=x/44100;
r:=0.4*sin(2*pi*t*a)+0.3*sin(2*pi*t*a*0.8)+0.3*sin(2*pi*t*a*1.2);
Result:=Round(r*32766*((n-x)/n));
end;


var ff:string;

procedure writeall(c:Cardinal);
begin
w.sz_8:=36+c*2;
w.sz_44:=w.sz_8-36;
stream:=TFileStream.Create(ff,fmCreate);
stream.WriteBuffer(w,44+c*2);
stream.Free;
end;

function tofile(ff_:Pchar):double;cdecl;
begin
ff:=string(ff_);
w.riff:=RIFF;
for i:=0 to 31 do w.head[i]:=HEAD[i];
Result:=0;
end;

function sonar(aa,bb:Double):Double;cdecl;
begin
n:=44100;
a:=Round(aa);
b:=Round(bb);
for x:=0 to n do w.mel[x]:=f1(x);
writeall(n);
Result:=0;
end;

function deep(aa:Double):Double;cdecl;
begin
n:=44100*2;
a:=Round(aa);
for x:=0 to n do w.mel[x]:=f2(x);
writeall(n);
Result:=0;
end;

function beat(aa:Double;bb:Double):Double;cdecl;
begin
n:=44100;
a:=Round(aa); 
y:=Round(bb)/1000;
for x:=0 to n do w.mel[x]:=f3(x,y);
writeall(n);
Result:=0;
end;

function beam(aa:Double):Double;cdecl;
begin
n:=44100*2;
a:=Round(aa);
for x:=0 to n do w.mel[x]:=f4(x);
writeall(n);
Result:=0;
end;

function ping(aa:Double):Double;cdecl;
begin
n:=44100;
a:=Round(aa);
for x:=0 to n do w.mel[x]:=f5(x);
writeall(n);
Result:=0;
end;

function chord(aa:Double):Double;cdecl;
begin
n:=44100 div 2;
a:=Round(aa);
for x:=0 to n do w.mel[x]:=f6(x);
writeall(n);
Result:=0;
end;

function tempdir():pchar;cdecl;
begin
GetTempPathA(1024,@temp);
result:=temp;
end;

function rmdir(d:pchar):double;cdecl;
begin
if RemoveDir(string(d))then Result:=1 else Result:=0;
end;


exports sonar,deep,beat,beam,ping,chord,tofile,tempdir,rmdir;
begin end.

