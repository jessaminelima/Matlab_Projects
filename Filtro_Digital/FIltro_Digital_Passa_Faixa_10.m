clear all
close all
clc
% Created by : Jessamine Lima
%% Filtro Digital

%------------------------------------------------
%% Leitura do arquivo de �udio
[x,Fs]= audioread('AUDIO_10.wav');

% Apresentando o valor da frequ�ncia de amostragem
disp(Fs)

figure(1)
plot(x)
% No dom�nio do tempo n�o se enxerga o ru�do
title('Sinal de Entrada')
ylabel('Amplitude')
xlabel('Tempo')

%------------------------------------------------
%% Espectro do sinal de entrada

% Para obtermos o x[k], fazemos a FFT
X = fft(x);

% Reorganizamos o espectro para a ordem natural (-pi a pi)
X = fftshift(X);

% Para representar o resultado desta FFT em volts � necess�rio multiplicar 
% por 2 fazer a raz�o do resultado da FFT pelo n�mero de amostras do vetor
% que a FFT retornou (que coincide com o n�mero de amostras do vetor de
% entrada da FFT)
X = 2*(X./length(x));


% Como o espectro � composto por n�meros complexos, calcular seu m�dulo
X_modulo = abs(X); 

% Gerar um eixo de frequ�ncias discreto (Fs pelo numero de amostras)
delta_freq = Fs/length(X);
f = -Fs/2:delta_freq:Fs/2-delta_freq;

figure(2)
stem(f,X_modulo)
title('Espectro do Sinal de Entrada')
xlabel('Frequencia (Hz)')
ylabel('Magnitude (V)')
grid

%------------------------------------------------------------
%% Filtro para eliminar o tom do �udio

% frequ�ncia de transi��o inferior
Fci1 = 250;
Fci2 = 275;

% frequ�ncia de transi��o superior
Fcs1 = 3875; 
Fcs2 = 3900;

% frequ�ncias em rela��o a frequ�ncia de amostragem
wci1 = (Fci1/(Fs/2))*pi;
wci2 = (Fci2/(Fs/2))*pi;

wcs1 = (Fcs1/(Fs/2))*pi;
wcs2 = (Fcs2/(Fs/2))*pi;

% Largura da faixa de transi��o
wt =min((wci2 - wci1),(wcs2 - wcs1));

% Determinando as frequ�ncias de corte superior e inferior
fc1 = ((Fci1 + Fci2)/2)/(Fs/2);
fc2 = ((Fcs1 + Fcs2)/2)/(Fs/2);

ordem = [ceil(6.6*pi/wt)]; % Janela de Hamming

h2 = fir1(ordem,[fc1 fc2],'bandpass',hamming(ordem+1));

%--------------------------------------------------------------
%% Resposta em Frequ�ncia do Filtro
a = 1;
f = 0:(Fs/2) - 1;
[H,w]=freqz(h2,a,f,Fs);
mag = abs(H);

figure(3)
plot(f,mag);
grid
title('Resposta da Magnitude do Filtro')
xlabel('Frequencia (Hz)')
ylabel('Magnitude (V)')

figure(4)
DB = 20*log10(mag);
plot(f,DB);grid
title('Resposta da Magnitude do Filtro em dB')
xlabel('Frequencia (Hz)') 
ylabel('Magnitude (dB)')

%----------------------------------------
%% Filtragem do arquivo de �udio:

% Convolu��o da resposta ao impulso (h2) com sinal de �udio de entrada (x)
sinal_filtrado = conv(h2,x);
figure(5)
plot(sinal_filtrado)
title('Sinal Filtrado')
ylabel('Amplitude')
xlabel('Tempo')
%sound(sinal_filtrado,Fs);

% ----------------------------------------
%% An�lise Espectro Arquivo de �udio Filtrado

% Analise de Fourier. Calcular a Transformada Discreta de Fourier
X = fft(sinal_filtrado);
X_modulo = abs(X);


% Como a fft retorna inicialmente os valores da  parte positiva do espectro
% e depois a parte negativa, reorganizar para a ordem natural
X = fftshift(X);


% A fft do Matlab n�o tem seu resultado expresso em volts. Para representar
% o resultado desta fft em volts � necess�rio dividir o resultado da fft
% pelo n�mero de amostras do vetor que a fft retornou (que coincide com o
% n�mero de amostras do vetor de entrada da fft)
X = 2*(X./length(x));

% Como o espectro � composto por n�meros complexos, calcular seu m�dulo
X_modulo = abs(X);

%gerar um eixo de frequ�ncias discreto
delta_freq = Fs/length(X); 
f = -Fs/2:delta_freq:Fs/2-delta_freq;
%f=0:delta_freq:Fs-delta_freq;
figure(6)
stem(f,X_modulo)
title('Espectro do Sinal Filtrado')
xlabel('Frequencia (Hz)')
ylabel('Magnitude (V)')
grid

%------------------------------------------------------------