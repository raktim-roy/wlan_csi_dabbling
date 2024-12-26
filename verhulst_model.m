% Implementation of Verhlst model
% Clear all the data in the workspace
clear all;

% Input to the model

% Input Sequence from the refernce paper
% What ever we sequence we want to predict assume it as AGO Sequence
% This is because the prediction formula given in the paper is for 
% AGO sequence 

year= 2000:2008;
n_students = [269,291,355,498,596,722,784,791,905];

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
  B(i,2) = z(i)^2;
endfor

Y=n_students_prev(2:length(year))';

ab=((B'*B)^-1)*B'*Y;


for t=0:8
  
  numerator = ab(1)*n_students(1)
  denominator_1 = ab(2)*n_students(1)
  denominator_2 =(ab(1)-ab(2)*n_students(1))*exp(ab(1)*t)

  prediction(t+1) = numerator/(denominator_1+denominator_2)L
  prediction_paper(t+1) = 77.337231/(0.071016+0.216483*exp(-0.287499*t)) 

  prediction_2(t+1)= (n_students(1)-(ab(2)/ab(1)))*exp(-ab(1)*t)+(ab(2)/ab(1))

  %prediction_3= (1-exp(ab(1)))*(n_students(1)-(ab(2)/ab(1)))*exp(-ab(1)*t)

  error(t+1) = prediction(t+1) - n_students(t+1);
endfor




figure(1)
plot(year,prediction,year,prediction_paper,year,n_students);
figure(2)
plot(year,prediction_2,year,n_students);


%Verifying AGO
ago=0;
for i=1:length(year)
  ago =  ago + (n_students_prev(i));
  n_students_ago(i)= ago;
endfor

