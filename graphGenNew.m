function [inputGraph] = graphGenNew(image)

J=image;
sx=size(J,1);
sy=size(J,2);
cm_n=0;
CM=zeros(sx*sy,2);
inputGraph.B=zeros(2*sx+2*sy-4,1);
count_B=0;

sCM=sx*sy;

A=zeros(sCM,sCM);
inputGraph.P=zeros(sCM,sCM);

for i=1:sx
    for j=1:sy
%         if J(i,j)<250
            cm_n=cm_n+1;
            CM(cm_n,1)=i;
            CM(cm_n,2)=j;
            
            if i==1 || i==sx || j==1 || j==sy
                count_B=count_B+1;
                inputGraph.B(count_B)=cm_n;
            end
%         end
    end
end

for i=1:sCM
    for j=1:sCM
         if i~=j
            I1=J(CM(i,1),CM(i,2));
            I2=J(CM(j,1),CM(j,2));
            
            if double(I1)~= double(I2)    
               A(i,j)= abs(double(I1)-double(I2))/((CM(i,1)-CM(j,1))^2+(CM(i,2)-CM(j,2))^2)*255;
            else
               A(i,j)= 0.1 / ((CM(i,1)-CM(j,1))^2+(CM(i,2)-CM(j,2))^2)*255;  
            end
         end
    end
end
       
for i=1:sCM
    if sum(A(i,:))~=0
        inputGraph.P(i,:)=A(i,:)/sum(A(i,:));
    end
end

Degree=zeros(sCM,1);
D = zeros(sCM,sCM);
for i=1:sCM
    Degree(i)=sum(A(i,:));
    D(i,i) = Degree(i);
end

inputGraph.D=Degree;

inputGraph.GL=D^(-1/2)*(D-A)*D^(-1/2);

inputGraph.GL(:,inputGraph.B)=[];
inputGraph.GL(inputGraph.B,:)=[];

% sb=size(B,1);
% Bs=sort(B,'descend');
% for j=1:sb
%     i=Bs(j);
%     Delta(i,:)=[];
%     Delta(:,i)=[];
%     Degree(i,:)=[];
%     Degree(:,i)=[];
% end
% Delta_unsym=Degree^(-1)*Delta;
% Delta_sym=Degree^(-1/2)*Delta*Degree^(-1/2);

end

