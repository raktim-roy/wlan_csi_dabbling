% Implementation of Verhlst model
% Clear all the data in the workspace
clear all;

% Input to the model

% Input Sequence from the refernce paper
% What ever we sequence we want to predict assume it as AGO Sequence
% This is because the prediction formula given in the paper is for 
% AGO sequence 

year= 2000:2016;
%n_students = [269,291,355,498,596,722,784,791,905,910,914,1000,950,910,914,1000,950];
n_students = [2,2.9,3.5,4.8,5,7,7.8,7.91,9.5,9.10,9.14,10.00,9.50,9.10,9.14,10.00,9.50];



% Finding Actual Sequence
% Finding input sequence to generate above AGO sequence
n_students_prev(1)=n_students(1); 

for i=1:length(year)-1
  n_students_prev(i+1) =  n_students(i+1) - n_students(i);
endfor

% 2. Find the Mean generated sequence Z of 

z=zeros(1,length(year)-1);

for i=2:length(year)
  z(i-1)= (n_students(i)+n_students(i-1))/2;
endfor

B=zeros(length(year)-1,2)

for i=1:length(year)-1
  B(i,1) = -z(i);
  B(i,2) = 1;
endfor

Y=n_students_prev(2:length(year))';

ab=((B'*B)^-1)*B'*Y;


for t=0:length(year)-1
  
  prediction(t+1)= (n_students(1)-(ab(2)/ab(1)))*exp(-ab(1)*t)+(ab(2)/ab(1));

endfor

figure(2)
plot(year,prediction,year,n_students);
xlabel('year');
ylabel('Number of students');
legend('prediction','input')


%Verifying AGO
ago=0;
for i=1:length(year)
  ago =  ago + (n_students_prev(i));
  n_students_ago(i)= ago;
endfor

%Verifying AGO
ago=0;
for i=1:length(year)
  x_axis(i) =  log(prediction(i));
endfor

