%% Decision variables boundary repair
function X_dec=Boundary_Repair(X_dec,Lower,Upper)
    [nums,D]=size(X_dec);
     for i=1:nums
         for j=1:D
             if X_dec(i,j)<Lower(j)
                  X_dec(i,j)=0.5*(X_dec(i,j)+Lower(j));
             elseif X_dec(i,j)>Upper(j)
                  X_dec(i,j)=0.5*(X_dec(i,j)+Upper(j));
             end      
         end  
     end
end