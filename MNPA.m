%ELEC 4700
%Tariq Aboushaer
%101064544
%PA 7

set(0, 'DefaultFigureWindowStyle', 'docked')
clc; 
close all; 
clear all;


R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1; 
Ro = 1000; 

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G0 = 1/Ro;

alpha = 100;
C = 0.25;
L = 0.2;
Vi = zeros(100, 1);
Vo = zeros(100, 1);
V3 = zeros(100, 1);
w = pi;
Gbold = zeros(6, 6);

Gbold(1, 1) = 1;                                        
Gbold(2, 1) = G1; Gbold(2, 2) = -(G1 + G2); Gbold(2, 6) = -1;   
Gbold(3 ,3) = -G3; Gbold(3, 6) = 1;                       
Gbold(4, 3) = -alpha*G3; Gbold(4, 4) = 1;                        
Gbold(5, 5) = -(G4+G0); Gbold(5, 4) = G4;   
Gbold(6, 2) = -1; Gbold(6, 3) = 1;                



Cbold = zeros(6, 6);

Cbold(2, 1) = C; Cbold(2, 2) = -C;
Cbold(6, 6) = L;

Fbold = zeros(6, 1);
v = 0;

for V1 = -10:0.1:10
    v = v + 1;
    Fbold(6) = V1;
    
    Vm = Gbold\Fbold;
    Vi(v) = V1;
    Vo(v) = Vm(5);
    V3(v) = Vm(3);
    
end


figure()
plot(Vi, Vo);
hold on;
title('Vo vs Vi for DC Sweep (V1): -10 V to 10 V (TA 101064544)');
xlabel('Vi (V)')
ylabel('Vo (V)')
grid on;

figure()
plot(Vi, V3);
title('V3 vs Vi for DC Sweep (V1): -10 V to 10 V (TA 101064544)')
xlabel('Vi (V)')
ylabel('V3 (V)')
grid on;

vo2 = zeros(1000, 1); 
W = zeros(1000, 1);
Avlog = zeros(1000, 1);

for freq = linspace(0, 100, 1000)
    v = v+1;
    Vm2 = (Gbold+1j*freq*Cbold)\Fbold;
    W(v) = freq;
    vo2(v) = norm(Vm2(5));
    Avlog(v) = 20*log10(norm(Vm2(5))/10);
end 
    
figure()
plot(W, vo2)
title('w vs Vout (TA 101064544)')
xlabel('w (rad)')
ylabel('Av (dB)')
hold on;
grid on;


figure()
plot(W, Avlog)
title('w vs Gain (TA 101064544)')
xlabel('w (rad)')
ylabel('Av (dB)')
grid on;

CH = zeros(1000,1);
GH = zeros(1000,1);

for i = 1:1000
    Crandom = C + 0.5*randn();
    Cbold(2, 1) = Crandom; 
    Cbold(2, 2) = -Crandom;
    Cbold(3, 3) = L;
    Vm3 = (Gbold+1i*w*Cbold)\Fbold;
    CH(i) = Crandom;
    GH(i) = 20*log10(norm(Vm3(5))/10);
end

histogram(CH,100)
title('Distribution (TA 101064544)')
grid on;




