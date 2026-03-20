function Current_Figure = plot_ellipse_data(X,Y,Uc_X,Uc_Y,Current_Figure,Plot_Properties)
%Plot the provided X and Y Data along with uncertainty ellipses
%Notes: 
% Set the current figure using Current_Figure = figure(X) where X is the
% figure number.  Pass in the resulting handle Current_Figure in the
% function call.  For an existing figure, if you know the current figure #
% (eg. 1, 2, ...) you can pass the number in instead of the figure handle.
% 
% Plot_Properties should be a character string formated for a Matlab plot
% (see 'help plot' for valid plot character strings)
%
%plot_ellipse_data(X Data, Y Data, X Uncertainty, Y Uncertainty, Figure Handle, Plot Color)
%
%Written by: Dr. David MacNair
%Lasted Edited by: Dr. David MacNair
%Last Edited: 2022-05-19

%Set the Figure to Plot On
Current_Figure = figure(Current_Figure);

%Set hold on to prevent overwriting any existing data
%Note: Run "clf" before this function to clear the figure before plotting
hold on

%Plot the X and Y Data
plot(X,Y,Plot_Properties)

N = numel(X); %Determine Number of X Values

%If 1 Value Given for All Uc_X, Set It For All X Values
if numel(Uc_X)==1 %Check if only 1 Uc_X value is provided
    Uc_X = Uc_X*ones(N,1); %Create Vector of Uc_X Values
end

%If 1 Value Given for All Uc_Y, Set It For All Y Values
if numel(Uc_Y)==1 %Check if only 1 Uc_Y value is provided
    Uc_Y = Uc_Y*ones(N,1); %Create Vector of Uc_Y Values
end

%Plot Ellipses
N_p = 32; %Set the number of points to plot for each ellipse
for i_ellipse=1:N %Iterate Through Points
    theta = linspace(0,2*pi,N_p); %Create N_p equally spaced theta values between 0 and 2*pi
    
    
    %Determine the points to plot for each ellipse
    Xe = X(i_ellipse)+Uc_X(i_ellipse)*cos(theta); %Determine X Values of the Ellipse
    Ye = Y(i_ellipse)+Uc_Y(i_ellipse)*sin(theta); %Determine Y Values of the Ellipse
    
    %Plot the Ellipse
    plot(Xe,Ye,'color',[0.7 0.7 0.7],'HandleVisibility','off')
end