clear all, close all;

%% reading data from .csv files
% column names: Otwarcie,Najwyzszy,Najnizszy,Zamkniecie,Wolumen
% reading data without: first row (name of columns) and first column (date)
bgz = csvread('bgz_d.csv',1,1);
bzw = csvread('bzw_d.csv',1,1);
ing = csvread('ing_d.csv',1,1);
mbk = csvread('mbk_d.csv',1,1);
peo = csvread('peo_d.csv',1,1);

%% taking only closing price index from data
bgz_closing = bgz(:,3);
bzw_closing = bzw(:,3);
ing_closing = ing(:,3);
mbk_closing = mbk(:,3);
peo_closing = peo(:,3);

%% creation of ONE matrix with all data (each company closing price index)
closing_data(:,1) = bgz_closing;
closing_data(:,2) = bzw_closing;
closing_data(:,3) = ing_closing;
closing_data(:,4) = mbk_closing;
closing_data(:,5) = peo_closing;

%% taking information about size of data (rows, columns)
data_size = size(closing_data);
num_company = data_size(2);
num_records = data_size(1);
names = ['bgz'; 'bzw';'ing';'mbk';'peo']; % 1 colums with 5 rows

%% new range of data - update information
% data from 01 December 2017 to 29 March 2018
closing_data = closing_data(232:num_records,:);
% update information about rows(num_records) of data
data_size = size(closing_data);
num_records = data_size(1);

%% plot presenting all data (with new range to predict)
figure('Name', 'New range of data');
% plot for all data together
hold on;
plot(closing_data(:,:),'Linewidth',3);
axis tight;
legend(names(:,:));
title('Data from 01 December 2017 to 29 March 2018');
hold off;

%% basic statistics and plot about data closing price index
figure('Name', 'Statistics');
for com_num = 1:num_company
    subplot(num_company, 1, com_num); % 1 column with 'data_columns' rows
    plot(closing_data(:,com_num),'b','Linewidth',2);
    axis tight;
    % calculation of basic statistics
    m = mean(closing_data(:,com_num));
    s = std(closing_data(:,com_num));
    me = median(closing_data(:,com_num));
    sk = skewness(closing_data(:,com_num));
    k = kurtosis(closing_data(:,com_num));
    mi = min(closing_data(:,com_num));
    mx = max(closing_data(:,com_num));
    % adding title with basic statistics 
    com_title = sprintf('range: [ %.4f, %.4f ], mean: %.4f, standard deviation: %.4f, median: %.4f, skewness: %.4f, kurtosis: %.4f,',mi,mx,m,s,me,sk,k);
    title(com_title);
    legend(names(com_num,:));
end;

%% increments -- difference between today and yesterday
% we will not be using diff command, beacuse we want increment started form index 2
increment = zeros(num_records,num_company);
increment_moved = zeros(num_records, num_company);
for i = 2:num_records
    increment(i,:) = closing_data(i,:) - closing_data(i-1,:);
    increment_moved(i+1,:) = increment(i,:);
end;
figure('Name', 'Increments for each comapny presented on one plot');
hold on;
plot(increment(:,:),'Linewidth',2);
axis tight;
legend(names(:,:));
hold off;
    
figure('Name', 'Increments presented using subplot');
for com = 1:num_company
    subplot(num_company, 1, com);
    plot(increment(:,com),'Linewidth',2);
    axis tight;
    title(names(com,:));
end;

%% prediction using naive and increments methods
naive_prediction = zeros(num_records, num_company);
increm_prediction = zeros(num_records, num_company);
check_inc_pred = zeros(num_records, num_company);
for inx = 2:num_records
    % for each company we will predict value using 'naive method'
    % e.g closing_data(1,1) { today } = naive_prediction(2,1) {tomorrow }
    naive_prediction(inx,:) = closing_data(inx-1,:);
    % closing_data starts form index 1, but increments starts from index 2
    if (inx > 2)
        increm_prediction(inx,:) = closing_data(inx-1,:) + increment_moved(inx,:);
        check_inc_pred(inx,:) = 2*closing_data(inx-1,:)-closing_data(inx-2,:);
    end;
end;

%% plot for visualization of prediction
figure('Name', 'Predictions');
for com = 1:num_company
    subplot(num_company, 1, com);
    axis_X = 3 : num_records;
    plot(axis_X, naive_prediction(axis_X,com), 'b.');
    hold on;
    plot(axis_X,increm_prediction(axis_X,com), 'r--');
	axis tight;
    title(names(com,:));
    legend('Naive Prediction', 'Increments Prediction');
    % calculation of RMSE for each method of prediction
    RMSE_naive = sqrt(mean(closing_data(2:num_records,com) - naive_prediction(2:num_records,com))^2);
    RMSE_increm = sqrt(mean(closing_data(2:num_records,com) - increm_prediction(2:num_records,com))^2);
    % showing RMSE below the charts
    x_lab = sprintf('RMSE for Naive Prediction: %.5f, RMSE for Increments Prediction: %.5f', RMSE_naive, RMSE_increm);
    xlabel(x_lab);
end;

%% prediction for window
windows = [3 7 15 30];
win_len = length(windows);
pred = zeros(num_records, num_company);
legg = vertcat('dat', 'dat',  'dat', 'dat','dat', names(1,:),names(2,:),names(3,:),names(4,:),names(5,:));
for w = 1:win_len
    window = windows(w);
    f_name = sprintf('Prediction for window= %d', window);
    figure('Name', f_name);
    for i = 1:num_records
        if (i > window + 1 )
            pred(i,:) = mean(increment(i-window:i-1,:)) + closing_data(i-1,:);
        end;
    end;
	axisX = window + 2 : num_records;
	plot(closing_data(:,:), 'k');
	hold on;
    plot(axisX, pred(axisX,:),'Linewidth',2);
	axis tight;
    legend(legg);
    RMSE_win = sqrt(mean(closing_data(window+2:num_records,:) - pred(window+2:num_records,:)).^2);
    x_lab = sprintf('%.4f ', RMSE_win);
    xlabel(x_lab);
    tit_win = sprintf('RMSE for (bgz, bzw, ing, mbk, peo) below the plot [window=%d] ',window);
    title(tit_win);
end;
