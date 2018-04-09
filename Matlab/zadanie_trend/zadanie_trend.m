%{ 
    Zadanie na temat: aproksymacji liniowej oraz wielowymiarowej.
    W zadaniu u¿yto funkcji: polyfit, polyval.
%}

close all, clear all;
N = 3; %ilosc kolumn
wiersze = 1000;
macierz = randi([-5 10],wiersze,N); %calkowite liczby z przedzialu (-5,10)
kolejnosc = [1:wiersze]';

figure('Name', 'DANE');
for i = 1:N
    subplot(N,1,i);
    plot(macierz(:,i),'r');
end;

% Trend liniowy (dla ka¿dej kolumny danych) wraz z wykresami
figure('Name', 'Dane z aproksymacja liniowa (y = ax + b)');
for i = 1:N
    subplot(N,1,i);
    liniowo = polyfit(kolejnosc, macierz(:,i), 1); % 1, bo to ilosc iksow liniowo
    f1 = polyval(liniowo,macierz(:,i));
    plot(kolejnosc, macierz(:,i), 'r');
    hold on;
    plot(kolejnosc, f1, 'b');
    hold off;
    rownanie = sprintf('y = %.4f x + %.4f', liniowo(2), liniowo(1));
    legend('DANE', rownanie);
end;

% 4. Trend wielomianowy z wykresami
figure('Name', 'Dane z aproksymacja wielomianowa (wielomian kwadratowy) ');
for i = 1:N
    subplot(N,1,i);
    kwadratowy = polyfit(kolejnosc, macierz(:,i), 2); % rownanie kwadratowe
    % polyval(p,[5 7 9])
    apro = polyval(kwadratowy,macierz(:,i));
    plot(kolejnosc, macierz(:,i), 'r');
    hold on;
    plot(kolejnosc, apro, 'b');
    hold off;
    rownanie = sprintf('y = %.4f x2 + %.4f x + %.4f', kwadratowy(3), kwadratowy(2), kwadratowy(1));
    legend('DANE', rownanie);
end;


% zadanie 5 i 6 robione jednoczesnie (od razu mozna zmieniac liczbe przedzialow)
liczba_przedzialow = 10;
mnoznik = floor(wiersze/liczba_przedzialow);
tyt_przedzialy = sprintf('Dane z aproksymacja liniowa dla %d przedzialow', liczba_przedzialow);
figure('Name',tyt_przedzialy);
for kol = 1 : N
  for nr_przedzialu = 0:(liczba_przedzialow-1)
      osx(:,1) = (mnoznik * nr_przedzialu+1):(mnoznik * (nr_przedzialu+1) );
      x = macierz(osx,kol);
      liniowo_przedzial = polyfit(osx,x,1);
      trend_line = polyval(liniowo_przedzial,osx);
      subplot(N,1,kol);
      tyt_kol = sprintf('Szereg dla %d kolumny danych', kol);
      plot(osx,x); 
      hold on;
      plot(osx,trend_line,'r--');
      axis tight;
      title(tyt_kol);
      legend('Dane', 'Aproksymacje');
  end
end
