% ZADANIE 1 
clear all, close all; % usun wszystkie zmienne, zamknij wszystkie okna
%Otwarcie,Najwyzszy,Najnizszy,Zamkniecie,Wolumen
lotos = csvread('lotos_d.csv',1,1); % od 1 wiersza (bez nazw kolumn) 1 kolumny (bez daty)
orlen = csvread('orlen_d.csv',1,1); 
% obie dane sa notowane na tej samej gieldzie, wiec dane notowane w tym samym roku
rozmiar = size(lotos);
wiersze = rozmiar(1);
% rozmiar(1) - ilosc wierszy 
% liczymy prognozy tylko dla kursow zamkniecia
lotos_zamkniecie = lotos(1:wiersze,3);
orlen_zamkniecie = orlen(1:wiersze,3);
% obliczamy przyrosty -- roznica miedzy dniami
przyrost_lotos = diff(lotos_zamkniecie);
przyrost_orlen = diff(orlen_zamkniecie);
% przyrosty maja indeksy od 1 do 249 - przesuwamy indeks, aby byl tak jak
% przy wprowadzaniu danych (od 2 do 250)
przyrost_lotos2(2:wiersze,1) = przyrost_lotos;
przyrost_orlen2(2:wiersze,1) = przyrost_orlen;
% metoda prognozowania naiwnego oraz z przyrostami
lotos_prognoza1 = zeros(wiersze, 1);
orlen_prognoza1 = zeros(wiersze, 1);
prognoza_z_przyrostami_lotos = zeros(wiersze,1);
prognoza_z_przyrostami_orlen = zeros(wiersze,1);

for w = 2:wiersze
    lotos_prognoza1(w,1) = lotos_zamkniecie(w-1,1); % metoda szkolna/naiwna
    orlen_prognoza1(w,1) = orlen_zamkniecie(w-1,1);
    if (w > 2) % dopiero przy 3 indeksie mamy odnotowane przyrosty_lotos2
		% uwzglednienie przyrostow na dzien w-1 przy prognozowaniu z uzyciem dnia w-1
		prognoza_z_przyrostami_lotos(w,1) = lotos_zamkniecie(w-1,1) + przyrost_lotos2(w-1,1);
        prognoza_z_przyrostami_orlen(w,1) = orlen_zamkniecie(w-1,1) + przyrost_orlen2(w-1,1);
        % lotos_z_przyrostami_SPRAWDZENIE(w,1) = 2*lotos_zamkniecie(w-1,1)-lotos_zamkniecie(w-2,1);
    end;
end;
RMSE1_lotos = sqrt(mean(lotos_zamkniecie(2:wiersze,1)-lotos_prognoza1(2:wiersze,1))^2);
RMSE2_lotos = sqrt(mean(lotos_zamkniecie(2:wiersze,1)-prognoza_z_przyrostami_lotos(2:wiersze,1))^2);
RMSE1_orlen = sqrt(mean(orlen_zamkniecie(2:wiersze,1)-orlen_prognoza1(2:wiersze,1))^2);
RMSE2_orlen = sqrt(mean(orlen_zamkniecie(2:wiersze,1)-prognoza_z_przyrostami_orlen(2:wiersze,1))^2);

figure;
os1 = 2:wiersze;
os2 = 3:wiersze;
subplot(2,1,1);
title('Grupa Lotos SA (LTS)');
bledy_lotos = sprintf('RMSE1 (naiwna) = %.2f, RMSE2 (z przyrostami)= %.2f',RMSE1_lotos,RMSE2_lotos);
xlabel(bledy_lotos);
plot(lotos_zamkniecie);
hold on;
plot(os1, lotos_prognoza1(os1,1), 'r:');
plot(os2, prognoza_z_przyrostami_lotos(os2,1), 'g--');
legend('lotos zamkniecie', 'prognoza naiwna', 'prognoza z przyrostami');
axis tight;

subplot(2,1,2);
title('Polski Koncern Naftowy ORLEN SA (PKN)');
bledy_orlen = sprintf('RMSE1 (naiwna) = %.2f, RMSE2 (z przysostami) = %.2f', RMSE1_orlen, RMSE2_orlen);
xlabel(bledy_orlen);
plot(orlen_zamkniecie);
hold on;
plot(os1, orlen_prognoza1(os1, 1), 'r:');
plot(os2, prognoza_z_przyrostami_orlen(os2, 1), 'g--'); axis tight;
legend('orlen zamkniecie', 'prognoza naiwna', 'prognoza z przyrostami');


Okna = [5 10 21];
liczba_Okna = length(Okna);
% LOTOS
lotos_przyrosty_okna = zeros(wiersze,1);
yPrOk_lotos = zeros(wiersze,liczba_Okna);
figure('Name', 'LOTOS');
for o = 1:liczba_Okna
    okno = Okna(o);
    for t = 2:wiersze
        if(o == 1) % przyrosty wyliczane tylko raz -- na poczatku 
            lotos_przyrosty_okna(t,1) = lotos_zamkniecie(t,1) - lotos_zamkniecie(t-1,1);
        end;
        if(t > okno + 1)
            yPrOk_lotos(t,o) = mean(lotos_przyrosty_okna(t-okno:t-1,1)) + lotos_zamkniecie(t-1,1);
        end;
    end;
    subplot(liczba_Okna, 1,o);
    osx=okno+2:wiersze;
    plot(lotos_zamkniecie,'b'); 
    hold on; 
    plot(osx,yPrOk_lotos(osx,o),'r'); 
    axis tight;
    RMSE_okna = sqrt(mean(lotos_zamkniecie(2:wiersze,1)-yPrOk_lotos(2:wiersze,1))^2);
    tyt_wykresu = sprintf('RMSE = %.4f',RMSE_okna);
    title(tyt_wykresu);
end;

% ORLEN
orlen_przyrosty_okna = zeros(wiersze,1);
yPrOk_orlen = zeros(wiersze,liczba_Okna);
figure('Name', 'ORLEN');
for o = 1:liczba_Okna
    okno = Okna(o);
    for t = 2:wiersze
        if(o == 1) % przyrosty wyliczane tylko raz -- na poczatku 
            orlen_przyrosty_okna(t,1) = orlen_zamkniecie(t,1) - orlen_zamkniecie(t-1,1);
        end;
        if(t > okno + 1)
            yPrOk_orlen(t,o) = mean(orlen_przyrosty_okna(t-okno:t-1,1)) + orlen_zamkniecie(t-1,1);
        end;
    end;
    subplot(liczba_Okna, 1,o);
    osx=okno+2:wiersze;
    plot(orlen_zamkniecie,'b'); 
    hold on; 
    plot(osx,yPrOk_orlen(osx,o),'r'); 
    axis tight;
    RMSE_okna = sqrt(mean(orlen_zamkniecie(2:wiersze,1)-yPrOk_orlen(2:wiersze,1))^2);
    tyt_wykresu = sprintf('RMSE = %.4f',RMSE_okna);
    title(tyt_wykresu);
end;


