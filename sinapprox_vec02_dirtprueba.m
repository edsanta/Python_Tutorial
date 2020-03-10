1;
clear all;
close all;
clc;

%datos
temp=load("./datos/gpB/005.dat");

for j=1:length(temp)
tiemp(j,:)=0.5*j;
endfor
%

global temp_pel=temp(:,2);
global temp_mues=temp(:,3);
global tiempot =tiemp;
datos=[tiempot,temp_pel,temp_mues];

%
%funcion vectorial
function result=Sn_form(tiempot,amp,freq,phi,beta)
   Sn=amp.*sin(2*pi.*freq.*tiempot+phi)+beta;
  result=Sn;
endfunction
%}

%
%modelo
function result=modelo(f_arg)
  amp=f_arg(1);
  freq=f_arg(2);
  phi=f_arg(3);
  beta=f_arg(4);
  
  global tiempot;
  global temp_pel;
  
  Sn=Sn_form(tiempot,amp,freq,phi,beta);
  
  result= sum((Sn-temp_pel).^2);
endfunction
%}

function result=modelo2(f_arg)
  amp=f_arg(1);
  freq=f_arg(2);
  phi=f_arg(3);
  beta=f_arg(4);
  
  global tiempot;
  global temp_mues;
  
  Sn=Sn_form(tiempot,amp,freq,phi,beta);
  
  result= sum((Sn-temp_mues).^2);
endfunction

%Evaluación
% [0.04,0.81]
m = 50;
bL = [0,0,pi,0];
bU = [15,1,3*pi,50];
Cr = 0.5;
gmax = 500;
[minimo_pel,amp_pel,freq_pel,phi_pel,beta_pel,tiempo_pel] = DE_ajuste(m,bL,bU,Cr,gmax,@modelo)
[minimo_mues,amp_mues,freq_mues,phi_mues,beta_mues,tiempo_mues] = DE_ajuste(m,bL,bU,Cr,gmax,@modelo2)
datgen_pel=Sn_form(tiempot,amp_pel,freq_pel,phi_pel,beta_pel);
datgen_mues=Sn_form(tiempot,amp_mues,freq_mues,phi_mues,beta_mues);

d=4.5e-3;
diffase1=abs(phi_mues-phi_pel)
diffase2=abs(diffase1-2*pi)
difusividad1=(pi*freq_pel*(d/diffase1)^2)*1e7
difusividad2=(pi*freq_pel*(d/diffase2)^2)*1e7
%{
figure
hold
scatter(tiempot,temp_pel)
plot(tiempot,datgen_pel)



figure
hold;
scatter(tiempot,temp_mues)
plot(tiempot,datgen_mues)
print -djpg gp02_002202_2

%
figure
hold;
plot(tiempot,temp_pel)
plot(tiempot,temp_mues)
%}

%{
figure
hold;
%scatter(tiempot,temp_pel)
plot(tiempot,temp_mues)
print -djpg Datos
%}

%{
figure
hold;
plot(tiempot,datgen_pel)
plot(tiempot,datgen_mues)
%
%}
