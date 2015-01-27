function [out1,out2]=obj_mat(center, data,dm1,U,expo)
out1 = zeros(size(center, 1), size(data, 1));
dm2=reshape(dm1,size(dm1,1)*size(dm1,2),1);
out2=zeros(size(center, 1), size(data, 1));
    for k = 1:size(center, 1),
	out1(k, :) = abs(center(k)-data)';
    end
r11=size(center,1);
c11=size(data,1);
for j=1:r11,
   for i=1:c11,                
        neigh=neighbor(dm1,i);     
%     tic
%         if mod(i,1000)==0, 
%  		fprintf('Number of 1000 calulations = %d\n', floor(i/1000));
%         end
%     toc
%        for k=1:size(neigh,1),
%             out2(i,j)=out2(i,j)+U(j,neigh(k))^(expo)*(dm2(neigh(k,1))-center(j))^2;
%        end    
       out2(j,i)=sum(U(j,neigh).^expo.*((dm2(neigh)-center(j)).^2)');    
   end
end 

     
function out=neighbor(dm1,i)
  out=[];
  r=size(dm1,1);
  c=size(dm1,2);
  %c1=floor(i/r)+1;
  r1=mod(i,r);
  if(r1==0),
      r1=r;
      c1=floor(i/r);
  else
      c1=floor(i/r)+1;        
  end
 temp=[-1 1;-1 0;1 -1;1 0;0 1;0 -1;1 1;-1 -1];
 temp(:,1)=temp(:,1)+r1;
 temp(:,2)=temp(:,2)+c1;
 if(r1==1 || c1==1 || r1==r || c1==c),   %Deal with boundary
 nr=find(temp(:,1)==0 | temp(:,1)==r+1);
 nc=find(temp(:,2)==0 | temp(:,2)==c+1);
 rc=union(nc,nr);
 temp(rc,:)=[];
 end
 temp(:,2)=temp(:,2)-1;
 out=temp*[1;r];
  
    
    
      