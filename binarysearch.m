function [m,q]=binarysearch(A,T)
    L=1;
    R=size(A,2);
    q=[0,0];
    while(L<=R)
        m=floor((L+R)/2);
        if A(m)<T
            L=m+1;
        elseif A(m)>T
            R = m-1;
        else
            break
        end
        q=[L,R];
        m=NaN;
    end
end 

                