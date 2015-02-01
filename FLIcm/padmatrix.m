function out=padmatrix(m,n)
  out=m;
  for i=1:n,
      out=padmatrix1(out);
  end
function out=padmatrix1(m)
   m=[m(:,1) m];
   m=[m m(:,size(m,2))];
   m=[m(1,:);m];
   m=[m;m(size(m,1),:)];
   out=m;