%% =========================================================
%  YAPAY ARI KOLONİSİ (YAK) ALGORİTMASI
%  Problem: Üretim Bandı Hızına Bağlı Kâr Optimizasyonu
%  Uygunluk Fonksiyonu: f(v) = -100v^2 + 600v + 100
%  Arama Uzayı: v ∈ [1, 5] m/s
%  Beklenen Optimum: v* = 3 m/s → f(v*) = 1000 birim
%% =========================================================
clear; clc; close all;
%% ---- 1. ALGORİTMA PARAMETRELERİ ----
ColonySize  = 20;       % Koloni büyüklüğü (işçi + gözcü arı çifti)
FoodNumber  = ColonySize / 2;   % Yiyecek kaynağı sayısı (işçi arı sayısı)
Limit       = 5;        % Kâşif arıya dönüşme eşiği (sömürü limiti)
MaxIter     = 50;       % Maksimum iterasyon sayısı
lb          = 1;        % Alt sınır (m/s)
ub          = 5;        % Üst sınır (m/s)
%% ---- 2. UYGUNLUK FONKSİYONU ----
fitness = @(v) -100*v.^2 + 600*v + 100;
%% ---- 3. BAŞLANGIÇ POPÜLASYONU ----
% Yiyecek kaynakları rastgele başlatılır
Foods   = lb + (ub - lb) * rand(FoodNumber, 1);   % Hız değerleri
f       = fitness(Foods);                           % Kâr değerleri
trial   = zeros(FoodNumber, 1);                     % Deneme sayacı
% Başlangıç popülasyonunu kaydet 
Foods_initial = Foods;
% En iyi çözümü takip et
[bestFit, bestIdx] = max(f);
bestFood = Foods(bestIdx);
%% ---- 4. YAK ALGORİTMASI DÖNGÜSÜ ----
iterBest    = zeros(MaxIter, 1);   % Her iterasyondaki en iyi kâr
iterMean    = zeros(MaxIter, 1);   % Her iterasyondaki ortalama kâr
iterMin_val = zeros(MaxIter, 1);   % Her iterasyondaki minimum kâr
iterBestV   = zeros(MaxIter, 1);   % Her iterasyondaki en iyi hız
for iter = 1:MaxIter
    %% --- FAZA 1: İŞÇİ ARI FAZASI (Yerel Arama) ---
    for i = 1:FoodNumber
        % Komşu kaynak rastgele seçilir (kendisi hariç)
        k = i;
        while k == i
            k = randi(FoodNumber);
        end
        phi = -1 + 2 * rand();   % [-1, 1] arasında rastgele sayı
        % Yeni aday hız (komşuluk hareketi)
        vNew = Foods(i) + phi * (Foods(i) - Foods(k));
        vNew = max(lb, min(ub, vNew));   % Sınır kontrolü
        fNew = fitness(vNew);
        % Açgözlü seçim: yeni çözüm daha iyiyse güncelle
        if fNew > f(i)
            Foods(i) = vNew;
            f(i)     = fNew;
            trial(i) = 0;
        else
            trial(i) = trial(i) + 1;
        end
    end
    %% --- FAZA 2: GÖZCÜ ARI FAZASI (Olasılıklı Seçim) ---
    % Roulette-wheel seçimi: daha kârlı kaynaklar daha sık seçilir
    prob = (f - min(f) + 1e-10) / (sum(f - min(f)) + 1e-10);
    t = 0;
    i = 1;
    while t < FoodNumber
        if rand() < prob(i)
            t = t + 1;
            % Komşu kaynak seç
            k = i;
            while k == i
                k = randi(FoodNumber);
            end
            phi  = -1 + 2 * rand();
            vNew = Foods(i) + phi * (Foods(i) - Foods(k));
            vNew = max(lb, min(ub, vNew));
            fNew = fitness(vNew);
            if fNew > f(i)
                Foods(i) = vNew;
                f(i)     = fNew;
                trial(i) = 0;
            else
                trial(i) = trial(i) + 1;
            end
        end
        i = mod(i, FoodNumber) + 1;
    end
    %% --- FAZA 3: KÂŞİF ARI FAZASI (Global Arama) ---
    % Limit'i aşan kaynaklar terk edilir, yeni rastgele kaynak üretilir
    for i = 1:FoodNumber
        if trial(i) >= Limit
            Foods(i) = lb + (ub - lb) * rand();
            f(i)     = fitness(Foods(i));
            trial(i) = 0;
        end
    end
    %% --- İTERASYON İSTATİSTİKLERİ ---
    % Anlık popülasyon istatistikleri (dalgalanma görmek için)
    [curBest, idx]    = max(f);
    iterMean(iter)    = mean(f);
    iterMin_val(iter) = min(f);
    % Global en iyi: bir kez bulunan optimum bir daha düşmez (kümülatif)
    if curBest > bestFit
        bestFit  = curBest;
        bestFood = Foods(idx);
    end
    iterBest(iter)  = bestFit;    % Kümülatif en iyi (monoton artan)
    iterBestV(iter) = bestFood;   % Kümülatif en iyi hız
end
%% ---- 5. SONUÇLARI YAZDIR ----
fprintf('==========================================\n');
fprintf('  YAK ALGORİTMASI OPTİMİZASYON SONUÇLARI\n');
fprintf('==========================================\n');
fprintf('  Optimum Bant Hızı   : %.6f m/s\n', bestFood);
fprintf('  Maksimum Kâr        : %.4f birim\n', bestFit);
fprintf('  Analitik Optimum    : v* = 3.000000 m/s\n');
fprintf('  Analitik Maks. Kâr  : f(3) = 1000 birim\n');
fprintf('  Hız Hatası          : %.2e m/s\n', abs(bestFood - 3));
fprintf('  Kâr Hatası          : %.2e birim\n', abs(bestFit - 1000));
fprintf('==========================================\n');
%% ====================================================
%  GRAFİKLER
%% ====================================================
%% --- GRAFİK 1: Uygunluk Fonksiyonu Eğrisi ---
figure('Name','Grafik 1 - Uygunluk Fonksiyonu','NumberTitle','off',...
       'Position',[50 550 560 420]);
v_plot = linspace(0.5, 5.5, 500);
f_plot = fitness(v_plot);
plot(v_plot, f_plot, 'b-', 'LineWidth', 2.5);
hold on;
plot(bestFood, bestFit, 'r*', 'MarkerSize', 14, 'LineWidth', 2);
xline(3, 'g--', 'LineWidth', 1.5, 'Label', 'v* = 3 m/s');
yline(1000, 'm--', 'LineWidth', 1.5, 'Label', 'f_{max} = 1000');
xlabel('Bant Hızı  v  (m/s)', 'FontSize', 12);
ylabel('Günlük Net Kâr  f(v)  (birim)', 'FontSize', 12);
title('f(v) = -100v^2 + 600v + 100 — Uygunluk Fonksiyonu', 'FontSize', 13);
legend({'f(v) eğrisi', sprintf('YAK çözümü: v=%.4f, f=%.2f', bestFood, bestFit)},...
       'Location','south', 'FontSize', 10);
grid on;
xlim([0.5 5.5]);
%% --- GRAFİK 2: Yakınsama Grafiği (En İyi Kâr vs İterasyon) ---
figure('Name','Grafik 2 - Yakınsama Grafiği','NumberTitle','off',...
       'Position',[630 550 560 420]);
plot(1:MaxIter, iterBest, 'r-o', 'LineWidth', 2, 'MarkerSize', 4);
yline(1000, 'k--', 'LineWidth', 1.5, 'Label', 'Analitik Optimum = 1000');
xlabel('İterasyon Sayısı', 'FontSize', 12);
ylabel('En İyi Kâr (birim)', 'FontSize', 12);
title('YAK Algoritması — En İyi Kâr Yakınsama Grafiği', 'FontSize', 13);
legend({'En İyi Kâr (iterasyon)'}, 'Location', 'southeast', 'FontSize', 10);
grid on;
xlim([1 MaxIter]);
ylim([min(iterBest)*0.95, 1050]);
%% --- GRAFİK 3: Maksimum / Ortalama / Minimum Kâr Grafiği ---
figure('Name','Grafik 3 - Max/Ort/Min Kâr','NumberTitle','off',...
       'Position',[50 80 560 420]);
plot(1:MaxIter, iterBest,    'r-',  'LineWidth', 2.0); hold on;
plot(1:MaxIter, iterMean,    'b--', 'LineWidth', 1.8);
plot(1:MaxIter, iterMin_val, 'g:',  'LineWidth', 1.8);
yline(1000, 'k--', 'LineWidth', 1.2, 'Label', 'Analitik Optimum');
xlabel('İterasyon Sayısı', 'FontSize', 12);
ylabel('Kâr (birim)', 'FontSize', 12);
title('YAK Algoritması — Popülasyon Kâr İstatistikleri', 'FontSize', 13);
legend({'Maksimum Kâr','Ortalama Kâr','Minimum Kâr'},...
       'Location','southeast', 'FontSize', 10);
grid on;
xlim([1 MaxIter]);
%% --- GRAFİK 4: Başlangıç ve Son Popülasyon Dağılımı ---
figure('Name','Grafik 4 - Popülasyon Dağılımı','NumberTitle','off',...
       'Position',[630 80 560 420]);
v_plot = linspace(0.5, 5.5, 500);
f_plot_bg = fitness(v_plot);
plot(v_plot, f_plot_bg, 'k-', 'LineWidth', 1.5, 'DisplayName', 'f(v)');
hold on;
% Başlangıç popülasyonu
scatter(Foods_initial, fitness(Foods_initial), 80, 'b', 'o', 'filled',...
        'DisplayName', 'Başlangıç Popülasyonu');
% Son popülasyon
scatter(Foods, fitness(Foods), 80, 'r', '^', 'filled',...
        'DisplayName', 'Son Popülasyon');
% Optimum nokta
plot(bestFood, bestFit, 'k*', 'MarkerSize', 14, 'LineWidth', 2,...
     'DisplayName', sprintf('Optimum: v=%.4f, f=%.2f', bestFood, bestFit));
xlabel('Bant Hızı  v  (m/s)', 'FontSize', 12);
ylabel('Kâr  f(v)  (birim)', 'FontSize', 12);
title('Başlangıç vs. Son Popülasyon Dağılımı', 'FontSize', 13);
legend('Location','south', 'FontSize', 9);
grid on;
xlim([0.5 5.5]);
%% --- GRAFİK 5: En İyi Hız Değerinin İterasyona Göre Değişimi ---
figure('Name','Grafik 5 - En İyi Hız Yakınsaması','NumberTitle','off',...
       'Position',[340 320 560 420]);
plot(1:MaxIter, iterBestV, 'm-s', 'LineWidth', 2, 'MarkerSize', 4);
yline(3, 'k--', 'LineWidth', 1.5, 'Label', 'Analitik Optimum v* = 3');
xlabel('İterasyon Sayısı', 'FontSize', 12);
ylabel('En İyi Hız  v  (m/s)', 'FontSize', 12);
title('YAK Algoritması — En İyi Hız Yakınsama Grafiği', 'FontSize', 13);
legend({'En İyi Hız (iterasyon)'}, 'Location','northeast', 'FontSize', 10);
grid on;
xlim([1 MaxIter]);
ylim([lb-0.2, ub+0.2]);
