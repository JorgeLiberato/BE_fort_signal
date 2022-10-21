clear all
close all
clc

s = tf('s');

num = 1;
den = 1;

num1 = 1;
den1 = 1;

sim("BEIdentifEleve12.mdl")

figure
plot(t,yr)
title("Système Réel")
grid on

figure
plot(t,yf)
title("Système filtrée")
grid on

ke_r = yr(end);
ke_f = yf(end);

figure
plot(t,yf,t,100*first_derivative.Data,t,10000*second_derivative.Data)
legend("Y filtrée","100x First derivative","10000x Second derivative")
title("Comparison")
grid on
grid minor

[der_inf,i_inf] = max(first_derivative.Data);
yf_inf = yf(i_inf);
t_inf = t(i_inf);

x = 39:(272+39);
a = der_inf;
b = yf_inf-a*t_inf;
reta = a*x+b;

figure
plot(t,yf,t_inf,yf_inf,'+')
hold on
plot(x,reta,'-')

format long
tau1 = -b/a;
tau2 = ((ke_f-b)/a)-tau1;


H = ke_f/((tau1*s+1)*(tau2*s+1));

num = H.Numerator{1};
den = H.Denominator{1};

num1 = 1;
den1 = 1;

sim("BEIdentifEleve12.mdl")

figure
plot(comparison.Time,comparison.Data)
ylim([0,12])    %Define o limite de cima e de baixo do eixo Y
legend('Système réel', 'Système identifié','Location','southeast')  %Legenda pra diferenciar qual curva é qual, e colocada no canto sudeste do gráfico
ylabel('y(t)')  %legenda do eixo y
xlabel('Time(s)')   %legenda do eixo x
title('Comparation entre les systèmes') %titulo
grid on %bota grade
grid minor %grade menor

figure
plot(ISE.Time,ISE.Data)

%Méthode échantillonnée
s = ke_f-yf;
S = s(21:1500);
n = length(S);

figure
plot(t,s)

s2=S(3:n);
s1=S(2:n-1);
s0=S(1:n-2);

B=s2./s0;
A=s1./s0;

figure
plot(A,B)

P = polyfit(A,B,1);
a1 = -P(1);
a2 = -P(2);
x = roots([1 a1 a2]);

tau12=-0.5./log(real(x));
tau1=tau12(1);
tau2=tau12(2);

s = tf('s');

H1 = ke_f/((tau1*s+1)*(tau2*s+1));

num1 = H1.Numerator{1};
den1 = H1.Denominator{1};

sim("BEIdentifEleve12.mdl")

figure
plot(comparison1.Time,comparison1.Data)
ylim([-0.5,12])    %Define o limite de cima e de baixo do eixo Y
legend('Système réel', 'Système identifié','Location','southeast')  %Legenda pra diferenciar qual curva é qual, e colocada no canto sudeste do gráfico
ylabel('y(t)')  %legenda do eixo y
xlabel('Time(s)')   %legenda do eixo x
title('Comparation entre les systèmes (méthode échantillonnée)') %titulo
grid on %bota grade
grid minor %grade menor