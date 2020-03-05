function [x,y,t,tau,taux]=newalternativetrapping(N,Dt)

    
    clear all;
    close all;
    clc;
    N=1e5;
    Dt=1e-3;
    kB = 1.38e-23;      % Boltzmann constant [J/K]
    T=300; %K

    S=load('specklesim.mat');
    Intensity=S.speckle.intensity;
    xpos=(S.speckle.x);%*5e-2; %temporary conversion to the different units (will be resolved later)
    ypos=(S.speckle.y);%*5e-2;
    
    rFibre = 52.5e-6; %S.speckle.rFibre;
    
    xcut = xpos(xpos > -rFibre/sqrt(2) & xpos < rFibre/sqrt(2) & ypos > -rFibre/sqrt(2) & ypos < rFibre/sqrt(2));
    ycut= ypos(xpos > -rFibre/sqrt(2) & xpos < rFibre/sqrt(2) & ypos > -rFibre/sqrt(2) & ypos < rFibre/sqrt(2));
    Intencut = Intensity(xpos > -rFibre/sqrt(2) & xpos < rFibre/sqrt(2), ypos > -rFibre/sqrt(2) & ypos < rFibre/sqrt(2),1);
    tic;


    %there is a possible problem with reshaping of the matrix but in here
    %it does not play a role as xpos, ypos are vectors.
    
    %{
    By resolving I mean changing back to the proper units and then
    propagating the laser axially.
    %}
    %figure();
    %pcolor(1e+6*xpos,1e+6*ypos,Intensity(:,:,1)), colormap hot, axis square, ...
    %    shading interp, xlabel('x-position, x / {\mu}m'), ...
    %    ylabel('y-position, y / {\mu}m');

    %for large arrays of intensity there will be a quadrile problem with
    %plotting unless shading interp used.
    
    %Normalizing by a maximum gradient
    %[Wx,Wy]=gradient(Intensity(:,:,1));
    %Wx_norm=Wx/norm(Wx);
    %Wy_norm=Wy/norm(Wy);
    %Normalizing by an average intensity
    Intensity_z=Intencut;
    normconst=10*kB*T;
    inten_norm=normconst*(Intensity_z)/mean(Intensity_z(:));
    [Wx_norm,Wy_norm] = (gradient(inten_norm,xpos(2)-xpos(1)));
    %figure(), pcolor(xcut*1e6,ycut*1e6,Wx_norm), colormap hot, shading interp, colorbar;
    
    %N=1e+5
    %kx=0; %1e-6;
    %ky=0; %1e-6;
    %kz=0; %0.2e-6;
    %Dt=1e-3; %s
    x1=19*1e-6; %m
    y1=-20*1e-6; %m
    %z1=0; %m
    R=1e-6; %m
    eta=0.001; %Pa*s
    d=2.6e+3; %kg/m3
    gamma = 6*pi*R*eta; % friction coefficient
    m = 4/3*pi*R^3*d;   % particle mass
    tau = m/gamma;      % momentum relaxation time
    D = 1*kB*T/gamma;     % diffusion coefficient (%multiplied by 10)
    x(1)=x1;y(1)=y1;%z(1)=z1;    % initial condition    
    kxx=1;%1e10*kB*T; 
    kyy=1;%1e10*kB*T;
    %{ When I set one of the constants to be 100
    %times smaller than the other one I get superdiffusion?
    taux = gamma/(normconst);
    %preallocating the memory to increase the speed? 
    %x=zeros(N); 
    %y=zeros(N);
    %but above raises error about maximum variable size?
    h = waitbar(0,'simulating...');
    for i = 2:1:N
        waitbar(i/N)
        % Deterministic step
        %[indexx,indexy]=arraymapping(x(i-1),y(i-1),xpos,ypos);
        %x(i) = x(i-1) - (kxx*Dt/gamma)*Wx_norm(indexx,indexy); %x(i-1);
        %y(i) = y(i-1) - (kyy*Dt/gamma)*Wy_norm(indexx,indexy); %y(i-1);
        
            
        [mx,qx]=binarysearch(xcut,x(i-1));
        [my,qy]=binarysearch(ycut,y(i-1));
        

        if isnan(mx) && isnan(my)
            WWx=[Wx_norm(qy(2),qx(2)), Wx_norm(qy(2),qx(1)); ...
                Wx_norm(qy(1),qx(2)), Wx_norm(qy(1),qx(1))];
            WWy=[Wy_norm(qy(2),qx(2)), Wy_norm(qy(2),qx(1)); ...
                Wy_norm(qy(1),qx(2)), Wy_norm(qy(1),qx(1))];
            XCut=[xcut(qx(2)),xcut(qx(1))];
            YCut=[ycut(qy(2)),ycut(qy(1))];
            [XX,YY]=meshgrid(XCut,YCut);
            termx=interp2(XX,YY,WWx,x(i-1),y(i-1));
            termy=interp2(XX,YY,WWy,x(i-1),y(i-1));
        elseif isnan(mx)
            WWx=[Wx_norm(my,qx(2)), Wx_norm(my,qx(1)); ...
                Wx_norm(my,qx(2)), Wx_norm(my,qx(1))];
            WWy=[Wy_norm(my,qx(2)), Wy_norm(my,qx(1)); ...
                Wy_norm(my,qx(2)), Wy_norm(my,qx(1))];
            XCut=[xcut(qx(2)),xcut(qx(1))];
            WWWx=WWx(1,:);
            WWWy=WWy(1,:);
            termx=interp1(XCut,WWWx,x(i-1));
            termy=interp1(XCut,WWWy,x(i-1));
        elseif isnan(my)
            WWx=[Wx_norm(qy(2),mx), Wx_norm(qy(2),mx); ...
                Wx_norm(qy(1),mx), Wx_norm(qy(1),mx)];
            WWy=[Wy_norm(qy(2),mx), Wy_norm(qy(2),mx); ...
                Wy_norm(qy(1),mx), Wy_norm(qy(1),mx)];
            YCut=[ycut(qy(2)),ycut(qy(1))];
            WWWx=WWx(1,:);
            WWWy=WWy(1,:);
            termx=interp1(YCut,WWWx,y(i-1));
            termy=interp1(YCut,WWWy,y(i-1));
        else
            termx=Wx_norm(my,mx);
            termy=Wy_norm(my,mx);
        end

        
        x(i) = x(i-1) - (kxx*Dt/gamma)*termx;
        y(i) = y(i-1) - (kxx*Dt/gamma)*termy;
        if isnan(x(i))
            break
        end
        %z(i) = z(i-1) - kz*Dt/gamma*z(i-1);
        % Diffusive step
        x(i) = x(i) + sqrt(2*D*Dt)*randn();
        y(i) = y(i) + sqrt(2*D*Dt)*randn();
        %disp([sqrt(2*D*Dt)*randn(),kxx*Dt/gamma*Wx_norm(indexx,indexy),Wx_norm(indexx,indexy)])
        %z(i) = z(i) + sqrt(2*D*Dt)*randn();
    end
    close(h)
    toc;
    t = [0:Dt:(N-1)*Dt];
    figure;
    plot3(x,y,t);
    title('Random walk in the optical trap');
    xlabel('x [m]');
    ylabel('y [m]');
    zlabel('t [s]');
    %axis equal; %uncomment if 3D
    
    figure();
    pcolor(1e6*xcut,1e6*ycut,Intencut), colormap hot, axis square, ...
        shading interp, xlabel('x-position, x / {\mu}m'), ...
        ylabel('y-position, y / {\mu}m');
    hold on;
    plot(1e6*x(1:end),1e6*y(1:end),'b');
    %Different colors of the trace in a different time? 
    %plot(1e6*x(1:end/2),1e6*y(1:end/2),'b');
    %hold on;
    %plot(1e6*x(end/2:end),1e6*y(end/2:end),'g');


end