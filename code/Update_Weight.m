%% Weight vector assisted generation
function W=Update_Weight(W,N)
   num=size(W,1);
   New_W1=[]; New_W2=[];
   if num<N
       d=N-num;
       h1=ceil(d/2)+1;
       h2=max(d-h1,0);
       for i=1:h1
          New_W1=[New_W1;(W(i,:)+W(i+1,:))/2] ;      
       end
       if(h2>0)      
         for i=num:-1:num-h2+1
           New_W2=[New_W2;(W(i,:)+W(i-1,:))/2] ;   
         end             
       end  
   end
   W=[W;New_W1;New_W2];
end